; Optimality lenght is (:optlen 16)
; Solution is (:solution fuelup r0 l2,load c5 r0 l2,fly r0 l2 l0,unload c5 r0 l0,fuelup r0 l0,load c0 r0 l0,fly r0 l0 l2,unload c0 r0 l2,fuelup r1 l0,load c1 r1 l0,fly r1 l0 l1,unload c1 r1 l1,fuelup r1 l1,load c4 r1 l1,fly r1 l1 l0,unload c4 r1 l0)
(define (problem rocket_2_8_4)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1
	c0 c1
	c2 c3
	c4 c5
	c6 c7
	l0 l1
	l2 l3
	  )
  (:init
	(at r0 l2) (at r1 l0)
	
	(rocket r0) (rocket r1)
	(cargo c0) (cargo c1)
	(cargo c2) (cargo c3)
	(cargo c4) (cargo c5)
	(cargo c6) (cargo c7)
	(location l0) (location l1)
	(location l2) (location l3)
	
	(at c5 l2) (at c6 l1)
	(at c3 l3) (at c1 l0)
	(at c0 l0) (at c7 l2)
	(at c2 l3) (at c4 l1)
	  )
  (:goal (and 
	(at c0 l2) (at c2 l3)
	(at c6 l1) (at c5 l0)
	(at c1 l1) (at c7 l2)
	(at c3 l3) (at c4 l0)
	  )
  )
)
