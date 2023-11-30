; Optimality lenght is (:optlen 48)
; Solution is (:solution fuelup r0 l2,load c5 r0 l2,fly r0 l2 l1,unload c5 r0 l1,fuelup r0 l1,load c9 r0 l1,fly r0 l1 l2,unload c9 r0 l2,fuelup r0 l2,load c11 r0 l2,fly r0 l2 l3,unload c11 r0 l3,fuelup r0 l3,load c12 r0 l3,fly r0 l3 l0,unload c12 r0 l0,fuelup r1 l2,load c7 r1 l2,fly r1 l2 l0,unload c7 r1 l0,fuelup r1 l0,load c14 r1 l0,fly r1 l0 l3,unload c14 r1 l3,fuelup r1 l3,load c0 r1 l3,fly r1 l3 l2,unload c0 r1 l2,fuelup r2 l1,load c2 r2 l1,fly r2 l1 l3,unload c2 r2 l3,fuelup r2 l3,load c15 r2 l3,fly r2 l3 l1,unload c15 r2 l1,fuelup r2 l1,load c10 r2 l1,fly r2 l1 l0,unload c10 r2 l0,fuelup r2 l0,load c1 r2 l0,fly r2 l0 l2,unload c1 r2 l2,fuelup r3 l0,load c6 r3 l0,fly r3 l0 l1,unload c6 r3 l1)
(define (problem rocket_4_16_4)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2 r3
	c0 c1 c2 c3
	c4 c5 c6 c7
	c8 c9 c10 c11
	c12 c13 c14 c15
	l0 l1 l2 l3
	  )
  (:init
	(at r0 l2) (at r1 l2) (at r2 l1) (at r3 l0)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3)
	(cargo c4) (cargo c5) (cargo c6) (cargo c7)
	(cargo c8) (cargo c9) (cargo c10) (cargo c11)
	(cargo c12) (cargo c13) (cargo c14) (cargo c15)
	(location l0) (location l1) (location l2) (location l3)
	
	(at c4 l3) (at c10 l1) (at c11 l2) (at c14 l0)
	(at c12 l3) (at c3 l1) (at c13 l0) (at c5 l2)
	(at c15 l3) (at c1 l0) (at c8 l2) (at c2 l1)
	(at c6 l0) (at c7 l2) (at c0 l3) (at c9 l1)
	  )
  (:goal (and 
	(at c8 l2) (at c14 l3) (at c7 l0) (at c5 l1)
	(at c13 l0) (at c3 l1) (at c4 l3) (at c1 l2)
	(at c11 l3) (at c0 l2) (at c10 l0) (at c15 l1)
	(at c6 l1) (at c12 l0) (at c9 l2) (at c2 l3)
	  )
  )
)
