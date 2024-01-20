---
title: "Spin: Reducing State Space"
date: 2024-01-18
draft: false

author: "Luke Marzen" # multiple author: ["Me", "You"]
tags: ["formal methods", "promela", "spin", "verification"]
# description: "An optional description for SEO. If not provided, an automatically created summary will be used."

# cover:
  # for consistency aspect ratio should be 1.91:1
  # image: "image path"
  # caption: "text"
  # alt: "text"
  # hidden: false
  # hiddenInList: false
  # hiddenInSingle: false

showToc: true
TocOpen: true
hideSummary: false
searchHidden: false
---

Verification is a paramount and formidable challenge in software engineering.  Moreover, it serves as a pivotal process that distinguishes software engineering from mere software development.  [_Spin_](https://spinroot.com/spin/whatispin.html) is a popular open-source software verification tool that has seen continuous research and development since its inception at Bell Labs in 1980.[^spin]  Under the hood, Spin is an explicit-state model checker, meaning it exhaustively searches the entire state space of a model.

To check an algorithm or system using Spin you must first recode it in [_Promela_](https://spinroot.com/spin/Man/Quick.html), a C-like language used for defining a model for use with Spin.  Once a model is implemented in Promela, Spin can be used to find counter-traces to correctness constraints if any exist and otherwise formally verify the model.  Challenges arise when attempting to verify sufficiently complex systems or algorithms, particularly where the state space exceeds your system's memory capacity or when the search will take eons to complete.

[^spin]: https://spinroot.com/spin/whatispin.html

This article shares several _tips & tricks_ that aim to help you overcome challenges you may encounter when attempting to verify complex models.  First, we will discuss compile-time flags that can reduce memory requirements.  Then, I will present several techniques that focus on reducing a model's state space by modifying your model's Promela code without compromising the validity of the model.


## Compile-Time Flags

If you are running out of memory, there are flags you should pass to the compiler first before attempting to reduce the state space.

Firstly, if you haven't already, increase the memory limit.  Of course, be aware of the resources available on your machine.

```bash {linenos=false}
-DMEMLIM=8000 # increases the maximum memory allocation to 8,000MB (8GB)
```

> set upperbound to the true number of Megabytes that can be allocated; usage, e.g.: -DMEMLIM=200 for a maximum of 200 Megabytes (meant to be a simple alternative to MEMCNT)

---

Spin provides quite a few flags focused on state space compression.  These have varying effectiveness and runtime costs.  I'll go over the most important ones here.

The first one to try is `-DCOLLAPSE`.  For my model, it reduced memory by 50% but increased runtime by 50%.

```bash {linenos=false}
-DCOLLAPSE
```

> a state vector compression mode; collapses state vector sizes by up to 80% to 90% (see Spin97 workshop paper) variations: add -DSEPQS or -DJOINPROCS (off by default)

---

Next is `-DSPACE`.  Using this flag, I saw a reduction in memory use by 15% without any meaningful increase in runtime.

```bash {linenos=false}
-DSPACE
```

> optimize for space not speed

---

`-DMA` is very effective at compression but increases runtime so much that time will probably become the dominant reason for being unable to verify your model.  On a small model, it increased the execution time by 60x!  It did however achieve the best compression yet compression at 17%.

```bash {linenos=false}
-DMA=N
```

> use a minimized DFA encoding for the state space, similar to a BDD, assuming a maximum of N bytes in the state-vector (this can be combined with -DCOLLAPSE for greater effect in cases when the original state vector is long)

---

You can use any combination of the above.  Experiment and find what works best for your model.  I had the greatest success with the following combination, which reduced memory use by 70% while with a runtime penalty of 60%...

```bash {linenos=false}
-DCOLLAPSE -DSPACE -DJOINPROCS
```

---

Be advised that there are some flags that will compress the state space, but do so by approximating it!
> The lossy compression methods can be more aggressive in saving memory use without incurring run-time penalties, by trading reductions in both memory use and speed for a potential loss of coverage.

These flags are...

```bash {linenos=false}
-DHC # hash-compaction, approximation
-DBITSTATE # supertrace, approximation
```

---

Now that you have slowed your program down using compression, you might be wondering if there is a way to make it faster.  The quickest and easiest way is to run your model across all the available threads of your machine.  For this, use the `-DNCORE=N` flag.  You won't get a linear speedup, but it does help.  Using 8 threads instead of 1, I achieved a speedup of 1.5x.

```bash {linenos=false}
-DNCORE=8 # runs the verification across 8 cores.
```

---

To see a complete list of flags, refer to the manual. [https://spinroot.com/spin/Man/Pan.html#B](https://spinroot.com/spin/Man/Pan.html#B)


## Reducing State Space

The following excerpt from Holzmann's book, _The Spin Model Checker: Primer and Reference Manual_[^holzmann2003], provides insightful perspective in this context.

> As the difference between a verification model and an implementation artifact becomes larger, one may well question if the facts that we are proving still have relevance. We take a very pragmatic view of this here. For our purposes, two models are equivalent if they have the same properties. This means that we can always simplify a verification model if its properties of interest are unaffected by the simplifications.

__Note__\
Before you attempt to implement any of the suggestions in this section, _validate_[^validation] your existing model.  After making modifications, re-validate your model to ensure that you haven't altered the behavior of your model.

One more thing: remember to measure the impact of your modifications.  Measuring/benchmarking is the most essential part of any optimization journey.  Some of the proposed ideas could possibly result in worse performance in terms of both time and space.

[^validation]: ___Validation___ is distinct from ___verification___.  In this context, _model validation_ is the process of assessing whether the model accurately represents the system it is intended to describe.


### Tip 1. Non-Deterministic Select

Avoid using the `select` keyword to non-deterministically choose a number in a range whenever possible.  Instead, use an equivalent `if` statement.  Using `select` hugely reduce search depth, runtime, and memory requirements.

Consider that you need to non-deterministically select a number in a range to index an array.  The range is known at compile-time via a parameter expressed as a pre-processor macro.

For this, Promela supplies the `select` keyword.  <https://spinroot.com/spin/Man/select.html>

```
NAME
select - non-deterministic value selection.

SYNTAX
select '(' name ':' expr '..' expr ')' 
```

Here is an example of how you would use the `select` statement it solve this problem...

<!-- TODO: Change language to Promela once Chroma verison is bumped for Hugo. -->
```c {lineNos=false}
select(addr: 0 .. LENGTH - 1)
```

Although the select statement achieves the desired effect, it causes an exponential state space explosion compared to the equivalent statement expressed using the `if` abstraction.

<!-- TODO: Change language to Promela once Chroma verison is bumped for Hugo. -->
```c
if
:: index = 0;
:: index = 1;
:: index = 2;
...
:: index = LENGTH - 1;
fi
```

The underlying reason for this seems to be that the `select` statement is converted to the following `do`\-loop.

<!-- TODO: Change language to Promela once Chroma verison is bumped for Hugo. -->
```c
do
:: index < LENGTH - 1 -> index++;
:: break;
od
```

Manually creating these `if` statements may not be scalable.  Unfortunately, as far as I am aware, promela does not provide a simple abstraction for creating `if` statements like I have shown above based on a range known at compile-time.  Generating the if statement with a pre-processor macro may be feasible using some tricks, but it is both very non-trivial and messy.  If you need a more scalable solution, then I would recommend creating a script to pre-process the Promela file to generate the `if` statements.  To this end, I have created a Python script and used a Makefile to handle my build process.  <https://github.com/lmarzen/mesi-verif/tree/main/model>

This technique only works when the upper and lower bounds are known at compile time.

<!-- 
I was looking into this issue more, because I thought I might be able to contribute this optimization to the spin project.

I found that the this optimization exists by looking into the Spin source code here.
[https://github.com/nimble-code/Spin/blob/c400fb339f505e0c9defc695604ede9cfe777f77/Src/spinlex.c#L1605](https://github.com/nimble-code/Spin/blob/c400fb339f505e0c9defc695604ede9cfe777f77/Src/spinlex.c#L1605)

```c {linenostart=1606}
   if (c == SELECT && Inlining < 0)
   { char name[64], from[32], upto[32];
    int i, a, b;
    new_select();
    if (!scan_to('(', 0, 0, 0)
    ||  !scan_to(':', isalnum, name, sizeof(name))
    ||  !scan_to('.', isdigit, from, sizeof(from))
    ||  !scan_to('.', 0, 0, 0)
    ||  !scan_to(')', isdigit, upto, sizeof(upto)))
    { goto not_expanded;
    }
    a = atoi(from);
    b = atoi(upto);
```
```c {linenostart=1627}
    if (b - a <= 32)
    { push_back("if ");
     for (i = a; i <= b; i++)
     { char buf[256];
      push_back(":: ");
      sprintf(buf, "%s = %d ",
       name, i);
      push_back(buf);
     }
     push_back("fi ");
    } 
```

All experiments were conducted on Spin Version 6.5.2.


This was introduced in Spin 6.4.3 in 2014 ([https://spinroot.com/fluxbb/viewtopic.php?id=1573](https://spinroot.com/fluxbb/viewtopic.php?id=1573))

I believe there are two issues with this implementation.

1.  The current solution is that it does not evaluate constant expressions, such as in my case of MEMORY\_SIZE - 1.
2.  It only works when the range is expressed as constant integers and when the range is not bigger than 32.  In my opinion 32 seems low, I suspect that this was chosen to reduce compile time and program size, however it may be worth measuring as I suspect that the tradeoff is worth it for even very large ranges.  Verifying the exponential explosion that a loop counter introduces is likely a much greater cost.  Most users would prefer a larger binary and increased compile time to a practically unverifiable system due to an unnecessarily exploded state space.
-->


### Tip 2. Abusing the Atomic Keyword

If verifying a parallel program, consider how `atomic` regions can be used to reduce state space without altering the behavior that you are interested in verifying.

I originally read about this idea in this 2007 article by Paul McKenney: <https://lwn.net/Articles/243851/](https://lwn.net/Articles/243851/>

If you are using `assert` statements in your code, then you can likely add an atomic statement around it and the following/previous statement.  The assert statements aren't part of the system you are verifying, so don't let them balloon your state space.  Check out the section titled _Promela Coding Tricks_ in McKenney's [article](https://lwn.net/Articles/243851/) for more examples and details.

If you have multiple assignments in a row that are not visible to other processes, then encapsulate them in an `atomic` region.

Before:

<!-- TODO: Change language to Promela once Chroma verison is bumped for Hugo. -->
```c
if
:: val1 = true;
:: val1 = false;
fi

val2 = 0;
```

After:

<!-- TODO: Change language to Promela once Chroma verison is bumped for Hugo. -->
```c {hl_lines=[1,8]}
atomic {
if 
:: val1 = true;
:: val1 = false;
fi

val2 = 0;
}
```

Using this tip in multiple places in one of my models reduced the state space to 1/10th the original size.  Execution time was similarly reduced significantly.


### Tip 3. Type Manipulation

Each of my processes has a value that keeps track of some state.  It is either 0 or 1.  I initially was using a `bool` to store this.  Seems like a reasonable data type, I thought.  As an experiment, I changed the type from a `bool` to a `byte`.

A reasonable person would expect that in the case that the underlying storage size for `bool` and `byte` are the same, the state-vector size won't change, and in the case that a `byte` is bigger, you would expect the size of the state-vector to increase.

To my surprise, this is not the case; using a "bigger" data type decreased the state-vector size!  So I tested for all data types, and here are my results.

| type  | state-vector size |
| ----- | ----------------- |
| bit   | 52B               |
| bool  | 52B               |
| byte  | 40B               |
| short | 52B               |
| int   | 56B               |

Very unexpected results.  My best guess is that there is some underlying compression happening that considers various data types differently or groups them in some way before compression.

In my experiments, there was no measurable impact on execution time when changing the data type.

The real tip here is to experiment with types that are "bigger" than is necessary and monitor how this impacts the state-vector size.  If you're thinking that this is insanely counter intuitive, I agree.


### Tip 4. The Smallest Sufficient Model

This is less of a trick and more of a reminder to keep the goal in sight.  Below, I have included an excerpt on this topic from _The Spin Model Checker: Primer and Reference Manual_[^holzmann2003].

> It is sometimes easy to lose sight of the one real purpose of using a model checking system: it is to verify system properties that cannot be verified adequately by other means. If verification is our objective, computational complexity is our foe. The effort of finding a suitable design abstraction is therefore the effort of finding the smallest model that is sufficient to verify the properties that we are interested in. No more, and no less. A one-to-one translation of an implementation into a verification modeling language such as PROMELA may pass the standard of sufficiency, but it is certainly not the smallest such model and may cause unnecessary complexity in verification, or even render the verification intractable. To reduce verification complexity we may sometimes choose to generalize a problem, and sometimes we may choose to specialize it.

My advice is to carefully consider whether each variable in your model is relevant to the properties you seek to verify.

[^holzmann2003]: G. J. Holzmann, _The Spin Model Checker: Primer and Reference Manual_. Addison-Wesley, 2003.


### ~~Tip 5.~~ Something That Didn't Work...

As part of a class project, I developed a model that keeps track of the state and tag of cache lines.

I initially represented both the state and tag using separate bytes.  I thought that I might be able to reduce memory requirements if I used the lower bits for the tag and using the upper bits for the state.  Bitwise operations were used to extract and update the data.

This had absolutely no impact.  There must be some underlying compression that makes this optimization for us.  I tested this with and without the compression flags discussed earlier, and the results were the same.


## Maximum Search Depth

I wanted to include this here since I ran into this problem when working on a model and was unable to find any resources that discussed this issue.

You might know that Spin has a default max search depth of 10,000 steps and that this search depth can be increased using the _-m_ pan flag.

From the [Spin Manual](https://spinroot.com/spin/Man/Pan.html):
> **-m***N* \
> set max search depth to *N* steps (default *N*=10000)

At a certain point (*N*=1,410,065,408 from what I encountered), the option will no longer increase the max search depth.  I suspect this is a hard limit of Spin, but I am curious why this is such an arbitrary number. Not a power of 2 - 1 as you might expect.  Furthermore, I am unsure whether this max search depth is consistent across different models or whether some models have higher or lower limits depending on some characteristic of the model.

I am unaware of any workarounds other than simplifying your model or applying some of the tricks in this article.

## Concluding Remarks

Utilizing a combination of the techniques presented here has the potential to transform a model that was previously unverifiable in practice into one that is now verifiable.

If you think there is an interesting trick that I missed or anything I got wrong, feel free to reach out to me.  You can find my contact information on my [about](/about/#contact) page.

