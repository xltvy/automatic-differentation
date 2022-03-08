; altay acar
; 2018400084
; compiling: yes
; complete: yes

#lang racket
(provide (all-defined-out))

;; given struct for the operations
(struct num (value grad)
    #:property prop:custom-write
    (lambda (num port write?)
        (fprintf port (if write? "(num ~s ~s)" "(num ~a ~a)")
            (num-value num) (num-grad num))))

; returns the values of the num structs given in num-list, if it is not a list, then returns int
(define (get-value num-list)
  (cond
    ; num-list consists of only one element
    ((not (list? num-list)) (num-value (eval num-list)))
    ; num-list is an empty list
    ((null? num-list) null)
    ; num-list is a list consisting multiple elements
    (else (cons (num-value (eval (car num-list))) (get-value (cdr num-list))))))

; returns the gradients of the num structs given in num-list, if it is not a list, then returns int
(define (get-grad num-list)
  (cond
    ; num-list consists of only one element
    ((not (list? num-list)) (num-grad (eval num-list)))
    ; num-list is an empty list
    ((null? num-list) null)
    ; num-list is a list consisting multiple elements
    (else (cons (num-grad (eval (car num-list))) (get-grad (cdr num-list))))))

; adds every element of a list
(define (lst-sum lst)
  (if (null? lst)
      0
      (+ (car lst) (lst-sum (cdr lst)))))

; returns the sum of values and gradients of multiple num structs as a new num struct
(define (add . args)
  (let ((res-num (num (lst-sum (get-value args))
                      (lst-sum (get-grad args)))))
    res-num))

; multiplicates every element of a list
(define (lst-mul lst)
  (if (null? lst)
      1
      (* (car lst) (lst-mul (cdr lst)))))

; multiplication of derivatives operation: the sum of multiplication of each term’s gradient with others’ values
(define (deriv-mul prod val-list grad-list)
  (if (null? val-list)
      0
      (+ (* (/ prod (car val-list)) (car grad-list)) (deriv-mul prod (cdr val-list) (cdr grad-list)))))

; returns a new num struct whose value field is the multiplication of parameter's value fields
; and grad field is the multiplication of derivatives operation of parameters
(define (mul . args)
  (let ((res-num (num (lst-mul (get-value args))
                      (deriv-mul (lst-mul (get-value args)) (get-value args) (get-grad args)))))
    res-num))

; returns a new num struct, whose value field is the result of value field of num1 - value field of num2
; for the grad field same operation applied to the grad fields
(define (sub num1 num2)
  (let ((res-num (num (- (num-value (eval num1)) (num-value (eval num2)))
                      (- (num-grad (eval num1)) (num-grad (eval num2))))))
    res-num))

; given rectified linear unit function
(define relu (lambda (x) (if (> (num-value x) 0) x (num 0.0 0.0))))

; given mean squared error function
(define mse (lambda (x y) (mul (sub x y) (sub x y))))

; concatenates key and value pairs for a hash into a one whole list
(define (concat keys values)
  (map (lambda (k v) `(,k ,v)) keys values))

; creates num struct statements for appropriate parameters
; every num has the grad 0.0 initially instead var, var has grad 1.0 initially
(define (create-num names values var)
  (if (null? names)
      null
      (cons (cond
          ((eq? var (car names)) (list 'num (car values) '1.0))
          (else (list 'num (car values) '0.0)))
        (create-num (cdr names) (cdr values) var))))

; creates a hash which contains numbers for each symbol with appropriate gradients
(define (create-hash names values var)
  (apply hash (foldr append '() (concat names (create-num names values var)))))

; parser function that translates the symbolic expression in expr into an appropriate expression
; by converting symbols in expr into their respective numbers in hash
(define (parse hash expr)
  (cond
    ; the expression is an empty list
    ((null? expr) null)
    ;the expression is a list
    ((list? expr) (cons (parse hash (car expr)) (parse hash (cdr expr))))
    ; the expression is an operator
    ((eq? '+ expr) 'add)
    ((eq? '* expr) 'mul)
    ((eq? '- expr) 'sub)
    ((eq? 'mse expr) 'mse)
    ((eq? 'relu expr) 'relu)
    ; the expression is a number
    ((number? expr) (list 'num expr '0.0))
    ; the expression is a symbol in hash
    (else (hash-ref hash expr))))

; returns the gradient of given expression, symbols and their respective values
(define (grad names values var expr)
  (num-grad (eval (eval (parse (create-hash names values var) expr)))))

; checks if the given element is in the list
(define (member? item list)
  (sequence-ormap (lambda (x)
                    (equal? item x))
                  list))

; helper function for partial gradients
(define (partial names values vars expr current)
  (if (member? current vars)
      (grad names values current expr)
      (grad names values 0 expr)))

; returns the list of partial gradients of given expression
(define (partial-grad names values vars expr)
  (map (lambda (iter) (partial names values vars expr iter)) names))

; changes the values of names in the direction that minimizes the value of expr by level lr
(define (gradient-descent names values vars lr expr)
  (map - values (map (lambda (x) (* x lr)) (partial-grad names values vars expr))))

; runs gradient-descent procedure iteratively k times
(define (optimize names values vars lr k expr)
  (if (= k 0)
      values
      (let ((new-value (gradient-descent names values vars lr expr)))
    (optimize names new-value vars lr (- k 1) expr))))