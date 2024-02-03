---
title: "Is Software Engineering Real Engineering?"
date: "2024-02-03"
draft: false

author: "Luke Marzen" # multiple author: ["Me", "You"]
tags: ["engineering"]
# description: "An optional description for SEO. If not provided, an automatically created summary will be used."

# cover:
  # for consistency aspect ratio should be 1.91:1
  # image: "cover.jpg"
  # caption: "text"
  # alt: "text"
  # hidden: false
  # hiddenInList: false
  # hiddenInSingle: false
  # hint: "photo" # https://gohugo.io/content-management/image-processing/#hint
  # quality: "85"
  # resampleFilter: "lanczos" # https://gohugo.io/content-management/image-processing/#resampling-filter

showToc: false
TocOpen: false
hideSummary: false
searchHidden: false
---

The debate over whether Software Engineering qualifies as a legitimate engineering discipline has been a persistent point of contention since the 1960s.  Software Engineering degree programs have only begun being offered by universities within the last two decades.

To unravel the question of whether Software Engineering is indeed a branch of engineering, we must first establish a clear definition of engineering and assess whether the characteristics associated with traditional engineering disciplines apply to Software Engineering.

Whatever the definition of engineering is, it must include all the traditionally accepted disciplines, including Chemical, Civil, Electrical, Mechanical, Nuclear, Aerospace, Industrial, etc, without being so broad that it includes fields that definitely aren't engineering.

The American Engineers' Council for Professional Development (ECPD, the predecessor of ABET) offers the following widely accepted definition.

> The creative application of scientific principles to design or develop structures, machines, apparatus, or manufacturing processes, or works utilizing them singly or in combination; or to construct or operate the same with full cognizance of their design; or to forecast their behavior under specific operating conditions; all as respects an intended function, economics of operation and safety to life and property.


There are many other definitions, but they generally consist of a subset of the following key elements.

- [Applied Science and Mathematics](#applied-science-and-mathematics)

- [Physical](#physical) <!-- design or develop structures, machines, apparatus, or manufacturing processes -->

- [Requirements and Constraints](#requirements-and-constraints) <!-- full cognizance of their design, under specific operating conditions -->

- [Consequential](#consequential) <!-- economics of operation and safety to life and property -->

- [Rigorous Evaluation and Analysis](#rigorous-evaluation-and-analysis) <!-- all as respects an intended function -->

- [Professionalism](#professionalism)


I will discuss each of these aspects in turn, presenting arguments for and against the legitimacy of Software Engineering.


## Applied Science and Mathematics

Software Engineering is fundamentally a sub-field of Computer Science, a study deeply intertwined with mathematics.


## Physical

Software is not physical.

The counterargument to this is more complex.  The assertion that engineering must be related to physics or physical nature is somewhat arbitrary.  Many definitions include the design of processes, such as the one above.  Specifically, the ECPD definition includes manufacturing processes. Furthermore, this definition is over-defined, as it excludes some commonly accepted engineering disciplines.  For example, some Systems Engineers work solely with the interactions between components and subsystems in a very conceptual and process-oriented manner.  So, engineering can apply to non-physical things.


## Requirements and Constraints

Software engineering projects can have long lists of requirements and constraints.  A well defined and understood solution is essential in any engineering discipline, including Software.

One of the goals of engineering is optimization.  Engineers are tasked with finding the best possible way to solve a problem.  The solution could be a latch, a circuit, or a software procedure; it doesn't matter so long as it fits the constraints and meets the requirements.  Oftentimes, engineers must minimize some combination of factors, such as materials used, energy consumption, cost, time, noise, etc.

There is an unattributed saying in engineering,

> Any idiot can build a bridge that stands, but it takes an engineer to build a bridge that barely stands.

The quote highlights that engineering is not just about achieving a functional outcome but a highly efficient one.

This idea is deeply embedded in software engineering.  Selecting and creating efficient algorithms and data structures are important considerations when balancing trade-offs in execution time, memory requirements, and implementation complexity.


## Consequential

If a social media platform is down, I am annoyed; if the building I'm in collapses, I am dead. 

This analogy, however, overly generalizes the impact of software.  There are instances where poorly designed software can have severe consequences, such as in critical systems in healthcare, transportation, and infrastructure.

- Therac-25: A radiation therapy machine malfunctioned and delivered lethal radiation doses to patients caused by a software race condition. Three dead, three critically injured.

- Boeing 737 MAX: The Maneuvering Characteristics Augmentation System (MCAS) could autonomously command the airplane to nosedive when just a single sensor gave bad data. 346 dead. Cost Boeing an estimated $80 billion.


## Rigorous Evaluation and Analysis

Given the consequential nature of engineering, rigorous evaluation and analysis is an indispensable part of the engineering process.  Prototyping, simulation and modeling, standards and codes, design reviews, and experimental testing are all regularly employed in engineering.

Software Engineering is no exception.  Numerous industries, companies, and engineering teams maintain coding standard documents encompassing various elements, including style preferences, standard processes, and verification requirements.  One such document is DO-178C, _Software Considerations in Airborne Systems and Equipment Certification_. DO-178C defines industry standards for software airworthiness, which are used by certification authorities such as the FAA.

Code is reviewed by other engineers to ensure quality, readability, adherence to coding standards, and maintainability.

Unit and functional testing are commonly used techniques to informally check correctness.  Software-in-the-loop (SIL) simulation can be employed to test code in a simulation environment.  Static analysis tools are used to analyze code for bugs and potential vulnerabilities without executing it.  Run-time health monitoring applications may be run alongside software to check for (un)expected behavior.  To formally prove correctness, model checkers and theorem provers may be used.  Techniques for testing and verification vary in complexity, cost, and feasibility, so careful consideration must be used to balance the methods used depending on the severity of a failure.

Rigorous evaluation and analysis is one of the most important factors that distinguishes Software Engineering from Software Development.


## Professionalism

Accreditation, licensure, and ethics are often promoted as prerequisites to Engineering.

### Education and Accreditation

As of writing, 54 institutions have an ABET-accredited Software Engineering Bachelor's Program.[^ABET-se]  The first Software Engineering ABET accreditations were awarded in 2001.  Since then, the number of institutions offering accredited Software Engineering programs has grown steadily.  This trend is likely to continue for the foreseeable future.

{{< figure
  src="se-abet-accreditations.png"
  alt="Graph depicting a steady increase in the number of ABET-accredited Software Engineering Bachelors Programs."
  width=100%
  responsive=false
>}}

### Licensure

The purpose of licensing is to protect public health, safety, and welfare from untrained individuals.

In the United States, "Engineer" is not a protected title, however, "Professional Engineer" is.  The National Council of Examiners for Engineering and Surveying (NCEES) began offering a Principles and Practice of Engineering (PE) Exam for Software Engineering in 2013, enabling Software Engineers to be legally recognized.  The NCEES discontinued the Software Engineering PE in 2019, citing a lack of participation.[^NCEES-se]  Other jurisdictions also have professional licensure for Software Engineers, including many European countries via the European Engineer (EUR ING) qualification, as well as some Canadian provinces.

In the United States, professional licensing is only common in Civil Engineering and related sub-disciplines.  Given this, the lack of widespread licensing is not a strong argument for the exclusion of Software Engineering as an Engineering discipline. 

Ultimately, licensing is political and administrative policy and not essential to performing engineering work itself.

### Ethical Responsibilities

Engineers must follow ethical standards.  Software Engineering has a well-established code of ethics, jointly created by ACM and IEEE-CS in 1997.[^ACM-ethics]


[^ECPD]: American Engineers' Council for Professional Development (ECPD, the predecessor of ABET)

[^ABET-se]: <https://www.abet.org/accreditation/find-programs/>

[^NCEES-se]: <https://ncees.org/ncees-discontinuing-pe-software-engineering-exam/>

[^ACM-ethics]: <https://ethics.acm.org/code-of-ethics/software-engineering-code/>


## Final Thoughts

Yes, Software Engineering is real Engineering.

Most articles I have come across which arrived at the opposite conclusion seem to conflate programming or software development with Software Engineering.

This is an important distinction to make since not all programmers or software developers are engineers.  While software development involves creating programs, software engineering encompasses broader engineering principles, including systematic design and evaluation.



<!--
Often pointed out is that Software Engineering can quickly iterate.

Software Engineering can be self-taught.

Version Control

Developer Conferences.

The heart of this debate really lies in the misappropriation of the title "Software Engineer."
[^IEEE-title]: <https://ieeeusa.org/assets/public-policy/positions/workforce/EngineerTitle1122.pdf>
-->
