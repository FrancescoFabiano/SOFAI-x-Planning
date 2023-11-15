; Optimality lenght is (:optlen 52)
; Solution is (:solution fuelup r0 l0,load c6 r0 l0,fly r0 l0 l1,unload c6 r0 l1,fuelup r0 l1,load c1 r0 l1,fly r0 l1 l5,unload c1 r0 l5,fuelup r0 l5,load c3 r0 l5,fly r0 l5 l6,unload c3 r0 l6,fuelup r0 l6,load c11 r0 l6,fly r0 l6 l2,unload c11 r0 l2,fuelup r0 l2,load c8 r0 l2,fly r0 l2 l4,unload c8 r0 l4,fuelup r0 l4,load c5 r0 l4,fly r0 l4 l3,unload c5 r0 l3,fuelup r0 l3,load c7 r0 l3,fly r0 l3 l0,unload c7 r0 l0,fuelup r1 l0,load c9 r1 l0,fly r1 l0 l3,unload c9 r1 l3,fuelup r1 l3,load c10 r1 l3,fly r1 l3 l2,unload c10 r1 l2,fuelup r1 l2,load c12 r1 l2,fly r1 l2 l6,unload c12 r1 l6,fuelup r1 l6,load c0 r1 l6,fly r1 l6 l1,unload c0 r1 l1,fuelup r1 l1,load c2 r1 l1,fly r1 l1 l5,unload c2 r1 l5,fuelup r1 l5,load c13 r1 l5,fly r1 l5 l0,unload c13 r1 l0)
(define (problem rocket_2_14_7)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1
	c0 c1
	c2 c3
	c4 c5
	c6 c7
	c8 c9
	c10 c11
	c12 c13
	l0 l1
	l2 l3
	l4 l5
	l6   )
  (:init
	(at r0 l0) (at r1 l0)
	
	(rocket r0) (rocket r1)
	(cargo c0) (cargo c1)
	(cargo c2) (cargo c3)
	(cargo c4) (cargo c5)
	(cargo c6) (cargo c7)
	(cargo c8) (cargo c9)
	(cargo c10) (cargo c11)
	(cargo c12) (cargo c13)
	(location l0) (location l1)
	(location l2) (location l3)
	(location l4) (location l5)
	(location l6) 
	(at c4 l4) (at c8 l2)
	(at c10 l3) (at c0 l6)
	(at c2 l1) (at c13 l5)
	(at c9 l0) (at c11 l6)
	(at c7 l3) (at c5 l4)
	(at c12 l2) (at c1 l1)
	(at c3 l5) (at c6 l0)
	  )
  (:goal (and 
	(at c12 l6) (at c11 l2)
	(at c7 l0) (at c1 l5)
	(at c6 l1) (at c4 l4)
	(at c9 l3) (at c2 l5)
	(at c5 l3) (at c13 l0)
	(at c10 l2) (at c0 l1)
	(at c3 l6) (at c8 l4)
	  )
  )
)
