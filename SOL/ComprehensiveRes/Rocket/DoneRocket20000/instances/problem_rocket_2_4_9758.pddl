; Optimality lenght is (:optlen 16)
; Solution is (:solution fuelup r0 l3,load c2 r0 l3,fly r0 l3 l2,unload c2 r0 l2,fuelup r0 l2,load c7 r0 l2,fly r0 l2 l0,unload c7 r0 l0,fuelup r0 l0,load c4 r0 l0,fly r0 l0 l1,unload c4 r0 l1,fuelup r0 l1,load c6 r0 l1,fly r0 l1 l3,unload c6 r0 l3)
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
	(at r0 l3) (at r1 l2)
	
	(rocket r0) (rocket r1)
	(cargo c0) (cargo c1)
	(cargo c2) (cargo c3)
	(cargo c4) (cargo c5)
	(cargo c6) (cargo c7)
	(location l0) (location l1)
	(location l2) (location l3)
	
	(at c1 l0) (at c6 l1)
	(at c2 l3) (at c0 l2)
	(at c7 l2) (at c3 l1)
	(at c5 l3) (at c4 l0)
	  )
  (:goal (and 
	(at c5 l3) (at c0 l2)
	(at c4 l1) (at c7 l0)
	(at c2 l2) (at c3 l1)
	(at c6 l3) (at c1 l0)
	  )
  )
)