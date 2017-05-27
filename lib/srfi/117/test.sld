(define-library (srfi 117 test)
  (import (scheme base) (srfi 117) (chibi test))
  (export run-tests)
  (begin
    (define (run-tests)
      (test-begin "srfi-117: list-queues")

      (test-group "list-queues/simple"
        (define x (list-queue 1 2 3))
        (define x1 (list 1 2 3))
        (define x2 (make-list-queue x1 (cddr x1)))
        (define y (list-queue 4 5))
        (define z (list-queue-append x y))
        (define z2 (list-queue-append! x (list-queue-copy y)))
        (test '(1 1 1) (list-queue-list (make-list-queue '(1 1 1))))
        (test '(1 2 3) (list-queue-list x))
        (test 3 (list-queue-back x2))
        (test-assert (list-queue? y))
        (test '(1 2 3 4 5) (list-queue-list z))
        (test '(1 2 3 4 5) (list-queue-list z2))
        (test 1 (list-queue-front z))
        (test 5 (list-queue-back z))
        (list-queue-remove-front! y)
        (test '(5) (list-queue-list y))
        (list-queue-remove-back! y)
        (test-assert (list-queue-empty? y))
        (test-error (list-queue-remove-front! y))
        (test-error (list-queue-remove-back! y))
        (test '(1 2 3 4 5) (list-queue-list z))
        (test '(1 2 3 4 5) (list-queue-remove-all! z2))
        (test-assert (list-queue-empty? z2))
        (list-queue-remove-all! z)
        (list-queue-add-front! z 1)
        (list-queue-add-front! z 0)
        (list-queue-add-back! z 2)
        (list-queue-add-back! z 3)
        (test '(0 1 2 3) (list-queue-list z)))

      (test-group "list-queues/whole"
        (define a (list-queue 1 2 3))
        (define b (list-queue-copy a))
        (test '(1 2 3) (list-queue-list b))
        (list-queue-add-front! b 0)
        (test '(1 2 3) (list-queue-list a))
        (test 4 (length (list-queue-list b)))
        (test '(1 2 3 0 1 2 3)
            (list-queue-list (list-queue-concatenate (list a b)))))

      (test-group "list-queues/map"
        (define r (list-queue 1 2 3))
        (define s (list-queue-map (lambda (x) (* x 10)) r))
        (define sum 0)
        (test '(10 20 30) (list-queue-list s))
        (list-queue-map! (lambda (x) (+ x 1)) r)
        (test '(2 3 4) (list-queue-list r))
        (list-queue-for-each (lambda (x) (set! sum (+ sum x))) s)
        (test 60 sum))

      (test-group "list-queues/conversion"
        (define n (list-queue 5 6))
        (define d (list 1 2 3))
        (define e (cddr d))
        (define f (make-list-queue d e))
        (define g (make-list-queue d e))
        (define h (list-queue 5 6))
        (define-values (dx ex) (list-queue-first-last f))
        (list-queue-set-list! n (list 1 2))
        (test '(1 2) (list-queue-list n))
        (test-assert (eq? d dx))
        (test-assert (eq? e ex))
        (test '(1 2 3) (list-queue-list f))
        (list-queue-add-front! f 0)
        (list-queue-add-back! f 4)
        (test '(0 1 2 3 4) (list-queue-list f))
        (test '(1 2 3 4) (list-queue-list g))
        (list-queue-set-list! h d e)
        (test '(1 2 3 4) (list-queue-list h)))

      (test-group "list-queues/unfold"
        (define (double x) (* x 2))
        (define (done? x) (> x 3))
        (define (add1 x) (+ x 1))
        (define x (list-queue-unfold done? double add1 0))
        (define y (list-queue-unfold-right done? double add1 0))
        (define x0 (list-queue 8))
        (define x1 (list-queue-unfold done? double add1 0 x0))
        (define y0 (list-queue 8))
        (define y1 (list-queue-unfold-right done? double add1 0 y0))
        (test '(0 2 4 6) (list-queue-list x))
        (test '(6 4 2 0) (list-queue-list y))
        (test '(0 2 4 6 8) (list-queue-list x1))
        (test '(8 6 4 2 0) (list-queue-list y1)))

      (test-end))))