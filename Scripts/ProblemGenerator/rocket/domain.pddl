;; Rockets domain: A logistic-like domain.
;; However, rockets can only fly once (they run out of fuel).
;; In problems rrt4 and rrt5 some passengers have to transit
;; several times to get to their destination.

(define (domain rocket)
  (:requirements :strips)
  (:predicates (cargo ?x) (rocket ?x) (location ?x)
	       (at ?t ?l) (in ?c ?r) (fuel ?r) (loaded ?r) (visited ?r ?l)
)

  (:action load
   :parameters (?c ?r ?l)
   :precondition (and (cargo ?c) (rocket ?r) (location ?l)
		      (at ?c ?l) (at ?r ?l) (not (loaded ?r)))
   :effect (and (not (at ?c ?l)) (in ?c ?r) (loaded ?r)))

  (:action unload
   :parameters (?c ?r ?l)
   :precondition (and (cargo ?c) (rocket ?r) (location ?l)
		      (in ?c ?r) (at ?r ?l) (loaded ?r))
   :effect (and (not (in ?c ?r)) (at ?c ?l) (not (loaded ?r))))

  (:action fly
   :parameters (?r ?dep ?dst)
   :precondition (and (rocket ?r) (location ?dep) (location ?dst)
		      (at ?r ?dep) (fuel ?r) (not (visited ?r ?dst)))
   :effect (and (not (at ?r ?dep)) (at ?r ?dst) (not (fuel ?r)) (visited ?r ?dst)))
   
  (:action fuelUp
   :parameters (?r ?dep)
   :precondition (and (rocket ?r) (location ?dep)
		      (at ?r ?dep) (not (fuel ?r)) (not (loaded ?r)))
   :effect (and (fuel ?r)))
)
