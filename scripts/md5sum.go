// code to generate hugo's MD5FromFileFast
// https://github.com/gohugoio/hugo/blob/master/helpers/general.go#L269
// Apache-2.0 license

package main

import (
	"crypto/md5"
	"encoding/hex"
	"flag"
	"fmt"
	"io"
	"os"
)

func main() {
	// Define command-line flags
	filePath := flag.String("file", "", "File path for which to generate MD5 hash")
	stringInput := flag.String("string", "", "String for which to generate MD5 hash")
	flag.Parse()

	// Check if either file or string input is provided
	if *filePath == "" && *stringInput == "" {
		fmt.Println("Please provide either a file path or a string for hashing.")
		return
	}

	// Generate MD5 hash for the given string
	if *stringInput != "" {
		hash := MD5String(*stringInput)
		// fmt.Printf("MD5 hash for the string '%s': %s\n", *stringInput, hash)
		fmt.Printf("%s", hash)
	}

	// Generate MD5 hash for the given file
	if *filePath != "" {
		file, err := os.Open(*filePath)
		if err != nil {
			fmt.Printf("Error opening file: %s\n", err)
			return
		}
		defer file.Close()

		hash, err := MD5FromFileFast(file)
		if err != nil {
			fmt.Printf("Error generating MD5 hash for file: %s\n", err)
			return
		}

		// fmt.Printf("MD5 hash for the file '%s': %s\n", *filePath, hash)
		fmt.Printf("%s", hash)
	}
}

// MD5String takes a string and returns its MD5 hash.
func MD5String(f string) string {
	h := md5.New()
	h.Write([]byte(f))
	return hex.EncodeToString(h.Sum(nil))
}

// MD5FromFileFast creates a MD5 hash from the given file.
func MD5FromFileFast(r io.ReadSeeker) (string, error) {
	const (
		maxChunks = 8
		peekSize  = 64
		seek      = 2048
	)

	h := md5.New()
	buff := make([]byte, peekSize)

	for i := 0; i < maxChunks; i++ {
		if i > 0 {
			_, err := r.Seek(seek, 0)
			if err != nil {
				if err == io.EOF {
					break
				}
				return "", err
			}
		}

		_, err := io.ReadAtLeast(r, buff, peekSize)
		if err != nil {
			if err == io.EOF || err == io.ErrUnexpectedEOF {
				h.Write(buff)
				break
			}
			return "", err
		}
		h.Write(buff)
	}

	return hex.EncodeToString(h.Sum(nil)), nil
}

