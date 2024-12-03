(define (domain briefcase)
(:requirements :strips)
(:types portable location)
(:predicates 
  (at ?x - portable ?l - location)
  (in ?x - portable)
  (is-at ?l - location))

(:action move
  :parameters (?m ?l - location)
  :precondition (is-at ?m)
  :effect (and
    (is-at ?l)
    (not (is-at ?m))))

(:action put-in
  :parameters (?x - portable ?l - location)
  :precondition (and
    (not (in ?x))
    (at ?x ?l)
    (is-at ?l))
  :effect (and
    (in ?x)
    (not (at ?x ?l))))

(:action take-out
  :parameters (?x - portable ?l - location)
  :precondition (and
    (in ?x)
    (is-at ?l))
  :effect (and
    (not (in ?x))
    (at ?x ?l))))
