; Optimality lenght is (:optlen 28)
; Solution is (:solution fuelup r0 l0,load c10 r0 l0,fly r0 l0 l1,unload c10 r0 l1,fuelup r0 l1,load c4 r0 l1,fly r0 l1 l2,unload c4 r0 l2,fuelup r0 l2,load c1 r0 l2,fly r0 l2 l3,unload c1 r0 l3,fuelup r0 l3,load c8 r0 l3,fly r0 l3 l0,unload c8 r0 l0,fuelup r1 l2,load c5 r1 l2,fly r1 l2 l3,unload c5 r1 l3,fuelup r1 l3,load c7 r1 l3,fly r1 l3 l1,unload c7 r1 l1,fuelup r1 l1,load c6 r1 l1,fly r1 l1 l2,unload c6 r1 l2)
(define (problem rocket_3_12_4)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2
	c0 c1 c2
	c3 c4 c5
	c6 c7 c8
	c9 c10 c11
	l0 l1 l2
	l3   )
  (:init
	(at r0 l0) (at r1 l2) (at r2 l1)
	
	(rocket r0) (rocket r1) (rocket r2)
	(cargo c0) (cargo c1) (cargo c2)
	(cargo c3) (cargo c4) (cargo c5)
	(cargo c6) (cargo c7) (cargo c8)
	(cargo c9) (cargo c10) (cargo c11)
	(location l0) (location l1) (location l2)
	(location l3) 
	(at c11 l3) (at c4 l1) (at c1 l2)
	(at c10 l0) (at c2 l2) (at c3 l0)
	(at c6 l1) (at c8 l3) (at c7 l3)
	(at c0 l0) (at c9 l1) (at c5 l2)
	  )
  (:goal (and 
	(at c5 l3) (at c3 l0) (at c10 l1)
	(at c4 l2) (at c0 l0) (at c9 l1)
	(at c11 l3) (at c6 l2) (at c7 l1)
	(at c1 l3) (at c2 l2) (at c8 l0)
	  )
  )
)
