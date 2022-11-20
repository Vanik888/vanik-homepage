package main

import (
	"fmt"
	"github.com/nfnt/resize"
	"image/jpeg"
	"io/ioutil"
	"log"
	"os"
)

func main() {
	var path = "./input_folder/"
	files, err := ioutil.ReadDir(path)
	if err != nil {
		log.Fatal(err)
	}
	// List files
	for _, f := range files {
		if f.IsDir() {
			continue
		}

		fmt.Printf("Processing %s\n", f.Name())

		// Open file
		file, err := os.Open(path + f.Name())
		if err != nil {
			log.Fatal(err)
		}

		// decode jpeg into image.Image
		img, err := jpeg.Decode(file)
		if err != nil {
			log.Fatal(err)
		}
		file.Close()

		// resize to width 1000 using Lanczos resampling
		// and preserve aspect ratio
		m := resize.Resize(1280, 0, img, resize.Lanczos3)

		out, err := os.Create(path + "resized/" + f.Name())
		if err != nil {
			log.Fatal(err)
		}
		defer out.Close()

		// write new image to file
		jpeg.Encode(out, m, nil)
	}
}
