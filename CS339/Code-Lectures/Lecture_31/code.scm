#lang sicp

(define (myif test opt1 opt2)
  (cond (test opt1)
        (else opt2)))

(define g 10)

(define (twenty)
  (set! g 20))
(define (thirty)
  (set! g 30))

(myif (> 20 10) (twenty) (thirty))

g   ; expected: 20 actual: 30

(define-syntax myif2
  (syntax-rules ()
    ((myif2 test opt1 opt2)
     (cond (test opt1)
           (else opt2)))))

(define h 10)

(define (twenty2)
  (set! h 22))
(define (thirty2)
  (set! h 32))

(myif2 (> 20 10) (twenty2) (thirty2))

h   ; prints 22

(define (myor1 a b)
  (if a
      a
      b))

(define-syntax myor2
  (syntax-rules ()
    ((myor2 a b)
     (if a
         a
         b))))

(define i 1)
(define (inc) (set! i (+ i 1)))

(myor2 (inc) 5)

i   ; expected: 2 actual: 3

(define-syntax myor3
  (syntax-rules ()
    ((myor3 a b)
     (let ((tmp a))
       (if tmp
           tmp
           b)))))

(define j 1)
(define (inc2) (set! j (+ j 1)))

(myor3 (inc2) 5)

j   ; prints 2

(or 2 3); 2
(or 2)  ; 2
(or)    ; Identity #f
(+)     ; Identity 0
(*)     ; Identity 1
(+ 2)   ; Add '2' with the identity
(* 3)   ; Multiply '3' with the identity

(define-syntax myorn
  (syntax-rules ()
    ((myorn)
     #f)    ; Identity of 'or'
    ((myorn a)
     a)     ; Or 'a' with the identity
    ((myorn a b . c)
     (let ((tmp a))
       (if tmp
           tmp
           (myorn b . c))))))

(myorn)
(myorn 10)
(myorn #f #t)
(myorn #f #f #f #t)

(define-syntax while
  (syntax-rules ()
    ((while condition . body)
     (let loop ()
       (cond (condition
	      (begin . body)
	      (loop)))))))

(define counter 5)
(while (> counter 0)
  (display counter)
  (newline)
  (set! counter (- counter 1)))

(let ((a 5) (b 10))
  (+ a b))

((lambda (a b) (+ a b))
  5 10)

(define-syntax for
  (syntax-rules ()
    ((for e in l . body)
     (map (lambda (e) . body) l))))

(define (sum-list l)
  (let ((sum 0))
    (for i in l
      (set! sum (+ sum i)))
    sum))

(sum-list '(1 2 3 4))