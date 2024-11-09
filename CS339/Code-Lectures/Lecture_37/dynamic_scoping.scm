#lang sicp

(define (myeval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env)) ((quoted? exp) (text-of-quotation exp)) ((assignment? exp) (eval-assignment exp env)) ((definition? exp) (eval-definition exp env)) ((if? exp) (eval-if exp env))
        ((lambda? exp) (make-procedure (lambda-parameters exp) (lambda-body exp)
                                       env))
        ((begin? exp)
         (eval-sequence (begin-actions exp) env))
        ((cond? exp) (myeval (cond->if exp) env))
        ((application? exp)
         (myapply (myeval (operator exp) env)
                  (list-of-values (operands exp) env)
                  env))
        (else
         (error "Unknown expression type: myeval" exp))))

(define (myapply procedure arguments env)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure procedure arguments))
        ((compound-procedure? procedure)
         (eval-sequence (procedure-body procedure)
                        (extend-environment
                          (procedure-parameters procedure)
                          arguments
                          env)))
        (else (error "Unknown procedure type: myapply" procedure))))

(define (list-of-values exps env) (if (no-operands? exps)
                                      '()
                                      (cons (myeval (first-operand exps) env)
                                            (list-of-values (rest-operands exps) env))))

(define (eval-if exp env)
  (if (true? (myeval (if-predicate exp) env))
      (myeval (if-consequent exp) env) (myeval (if-alternative exp) env)))


(define (eval-sequence exps env) (cond ((last-exp? exps)
                                        (myeval (first-exp exps) env))
                                       (else
                                        (myeval (first-exp exps) env) (eval-sequence (rest-exps exps) env))))


(define (eval-assignment exp env) (set-variable-value! (assignment-variable exp)
                                                       (myeval (assignment-value exp) env) env)

  'ok)

(define (eval-definition exp env) (define-variable! (definition-variable exp)
                                    (myeval (definition-value exp) env) env)
  'ok)

(define (self-evaluating? exp) (cond ((number? exp) true)
                                     ((string? exp) true) (else false)))

(define (variable? exp) (symbol? exp))

(define (quoted? exp) (tagged-list? exp 'quote))

(define (text-of-quotation exp) (cadr exp))

(define (tagged-list? exp tag) (if (pair? exp)
                                   (eq? (car exp) tag)
                                   false))

(define (assignment? exp) (tagged-list? exp 'set!))

(define (assignment-variable exp) (cadr exp))

(define (assignment-value exp) (caddr exp))

(define (definition? exp) (tagged-list? exp 'define))

(define (definition-variable exp)
                                                        (if (symbol? (cadr exp)) (cadr exp)
                                                            (caadr exp)))
(define (definition-value exp)
  (if (symbol? (cadr exp)) (caddr exp)
      (make-lambda (cdadr exp) (cddr exp))))
; formal parameters ; body

(define (lambda? exp) (tagged-list? exp 'lambda)) (define (lambda-parameters exp) (cadr exp)) (define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body) (cons 'lambda (cons parameters body)))

(define (if? exp) (tagged-list? exp 'if)) (define (if-predicate exp) (cadr exp)) (define (if-consequent exp) (caddr exp)) (define (if-alternative exp)
                                                                                                                            (if (not (null? (cdddr exp))) (cadddr exp)
                                                                                                                                'false))
(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

(define (begin? exp) (tagged-list? exp 'begin)) (define (begin-actions exp) (cdr exp))

(define (last-exp? seq) (null? (cdr seq))) (define (first-exp seq) (car seq)) (define (rest-exps seq) (cdr seq))

(define (sequence->exp seq) (cond ((null? seq) seq)
                                  ((last-exp? seq) (first-exp seq))
                                  (else (make-begin seq))))
(define (make-begin seq) (cons 'begin seq))

(define (application? exp) (pair? exp)) (define (operator exp) (car exp)) (define (operands exp) (cdr exp)) (define (no-operands? ops) (null? ops)) (define (first-operand ops) (car ops)) (define (rest-operands ops) (cdr ops))

(define (cond? exp) (tagged-list? exp 'cond)) (define (cond-clauses exp) (cdr exp))
(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))
(define (cond-predicate clause) (car clause))
(define (cond-actions clause) (cdr clause))
(define (cond->if exp) (expand-clauses (cond-clauses exp)))

(define (expand-clauses clauses)
  (if (null? clauses)
      'false ; no else clause
      (let ((first (car clauses)) (rest (cdr clauses)))
        (if (cond-else-clause? first) (if (null? rest)
                                          (sequence->exp (cond-actions first)) (error "ELSE clause isn't last: COND->IF"
                                                                                      clauses))
            (make-if (cond-predicate first)
                     (sequence->exp (cond-actions first)) (expand-clauses rest))))))

(define (true? x) (not (eq? x false))) (define (false? x) (eq? x false))

(define (make-procedure parameters body env) (list 'procedure parameters body env))
(define (compound-procedure? p) (tagged-list? p 'procedure))
(define (procedure-parameters p) (cadr p)) (define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))

(define (enclosing-environment env) (cdr env)) (define (first-frame env) (car env))
(define the-empty-environment '())

(define (make-frame variables values) (cons variables values))
(define (frame-variables frame) (car frame)) (define (frame-values frame) (cdr frame)) (define (add-binding-to-frame! var val frame)
                                                                                         (set-car! frame (cons var (car frame))) (set-cdr! frame (cons val (cdr frame))))
(define (extend-environment vars vals base-env) (if (= (length vars) (length vals))
                                                    (cons (make-frame vars vals) base-env) (if (< (length vars) (length vals))
                                                                                               (error "Too many arguments supplied" vars vals)
                                                                                               (error "Too few arguments supplied" vars vals))))
(define (lookup-variable-value var env) (define (env-loop env)
                                          (define (scan vars vals) (cond ((null? vars)
                                                                          (env-loop (enclosing-environment env))) ((eq? var (car vars)) (car vals))
                                                                                                                  (else (scan (cdr vars) (cdr vals)))))
                                          (if (eq? env the-empty-environment) (error "Unbound variable" var) (let ((frame (first-frame env)))
                                                                                                               (scan (frame-variables frame) (frame-values frame)))))
  (env-loop env))

(define (set-variable-value! var val env) (define (env-loop env)

                                            (define (scan vars vals) (cond ((null? vars)
                                                                            (env-loop (enclosing-environment env))) ((eq? var (car vars)) (set-car! vals val)) (else (scan (cdr vars) (cdr vals)))))
                                            (if (eq? env the-empty-environment) (error "Unbound variable: SET!" var) (let ((frame (first-frame env)))
                                                                                                                       (scan (frame-variables frame) (frame-values frame)))))
  (env-loop env))

(define (define-variable! var val env) (let ((frame (first-frame env)))
                                         (define (scan vars vals) (cond ((null? vars)
                                                                         (add-binding-to-frame! var val frame)) ((eq? var (car vars)) (set-car! vals val)) (else (scan (cdr vars) (cdr vals)))))
                                         (scan (frame-variables frame) (frame-values frame))))

(define (primitive-procedure? proc) (tagged-list? proc 'primitive))
(define (primitive-implementation proc) (cadr proc))

(define primitive-procedures (list (list 'car car)
                                   (list 'cdr cdr)
                                   (list 'cons cons)
                                   (list 'null? null?)
                                   (list '> >)
                                   (list 'expt expt)
                                   (list '+ +)
                                   (list '- -)
                                   (list '* *)
                                   (list '/ /)))
(define (primitive-procedure-names) (map car primitive-procedures))
(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))

(define (apply-primitive-procedure proc args) (apply (primitive-implementation proc) args))

(define (setup-environment) (let ((initial-env
                                   (extend-environment (primitive-procedure-names) (primitive-procedure-objects)
                                                       the-empty-environment))) (define-variable! 'true true initial-env)
                              (define-variable! 'false false initial-env)
                              initial-env))
(define the-global-environment (setup-environment))

;(myeval '(define (make-adder increment)
;    (lambda (x) (+ x increment))) the-global-environment)
;(myeval '((make-adder 3) 4) the-global-environment)
;(myeval '((make-adder 3) 4) (extend-environment '(increment) '(10) the-global-environment))

(myeval '(define (sum term a next n)
  (if (> a n)
      0
      (+ (term a)
         (sum term (next a) next n)))) the-global-environment)

(myeval '(define (sum-powers a b n)
  (define (inc x) (+ x 1))
  (define (nth-power x) (expt x n))
  (sum nth-power a inc b)) the-global-environment)

(myeval '(sum-powers 1 5 2) the-global-environment)