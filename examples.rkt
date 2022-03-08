#lang racket
(provide (all-defined-out))

(define g 9.81)

(define a 10)

(define name "altay")

(define square (lambda (x) (* x x)))
(let ([x 5]) (* x x))
(let* ([x 5] [xsquare (square x)]) xsquare)

(= 25 25) ; => #t
(= 25 25.0) ; => #t
(eq? 25 25.0) ; => #f
(eq? '(1 2) '(1 2)) ; => #f

; (if predicate iftrue_runthis iffalse_runthis)
; (define f (lambda (x) (if (even? x) (* x 2) (* x 3))))
(define f (lambda (x) (cond
	[(= x 1) "one"]
	[(= x 2) "two"]
	[(= x 3) 42]
	)))

(struct euclidean-vec (x y z))

; this is a comment

