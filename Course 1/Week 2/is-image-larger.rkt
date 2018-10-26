;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname is-image-larger) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)

;; Image Image -> Boolean
;; Given two images, produces true if the first image is larger than the second image

;; (define (is-image-larger? img1 img2) false) /stub
(check-expect (is-image-larger? (square 2 "solid" "blue") (square 1 "solid" "blue")) true)
(check-expect (is-image-larger? (square 1 "solid" "blue") (square 1 "solid" "blue")) false)
(check-expect (is-image-larger? (square 1 "solid" "blue") (square 2 "solid" "blue")) false)
(check-expect (is-image-larger? (circle 2 "solid" "blue") (circle 1 "solid" "blue")) true)

;; (define (is-image-larger? img1 img2) ... img1 img2) /template

(define (is-image-larger? img1 img2)
  (> (* (image-width img1) (image-height img1))
     (* (image-width img2) (image-height img2))))
