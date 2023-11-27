; Optimality lenght is (:optlen 56)
; Solution is (:solution fuelup r0 l0,load c0 r0 l0,fly r0 l0 l3,unload c0 r0 l3,fuelup r0 l3,load c5 r0 l3,fly r0 l3 l0,unload c5 r0 l0,fuelup r0 l0,load c9 r0 l0,fly r0 l0 l2,unload c9 r0 l2,fuelup r0 l2,load c3 r0 l2,fly r0 l2 l1,unload c3 r0 l1,fuelup r1 l1,load c1 r1 l1,fly r1 l1 l2,unload c1 r1 l2,fuelup r1 l2,load c10 r1 l2,fly r1 l2 l0,unload c10 r1 l0,fuelup r1 l0,load c13 r1 l0,fly r1 l0 l1,unload c13 r1 l1,fuelup r1 l1,load c16 r1 l1,fly r1 l1 l3,unload c16 r1 l3,fuelup r2 l0,load c11 r2 l0,fly r2 l0 l1,unload c11 r2 l1,fuelup r2 l1,load c4 r2 l1,fly r2 l1 l2,unload c4 r2 l2,fuelup r2 l2,load c15 r2 l2,fly r2 l2 l0,unload c15 r2 l0,fuelup r3 l3,load c7 r3 l3,fly r3 l3 l1,unload c7 r3 l1,fuelup r3 l1,load c12 r3 l1,fly r3 l1 l2,unload c12 r3 l2,fuelup r3 l2,load c17 r3 l2,fly r3 l2 l0,unload c17 r3 l0)
(define (problem rocket_5_20_4)
  (:domain rocket)
  (:requirements :strips)
  (:objects
	r0 r1 r2 r3 r4
	c0 c1 c2 c3 c4
	c5 c6 c7 c8 c9
	c10 c11 c12 c13 c14
	c15 c16 c17 c18 c19
	l0 l1 l2 l3   )
  (:init
	(at r0 l0) (at r1 l1) (at r2 l0) (at r3 l3) (at r4 l3)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3) (rocket r4)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3) (cargo c4)
	(cargo c5) (cargo c6) (cargo c7) (cargo c8) (cargo c9)
	(cargo c10) (cargo c11) (cargo c12) (cargo c13) (cargo c14)
	(cargo c15) (cargo c16) (cargo c17) (cargo c18) (cargo c19)
	(location l0) (location l1) (location l2) (location l3) 
	(at c8 l3) (at c16 l1) (at c9 l0) (at c10 l2) (at c12 l1)
	(at c13 l0) (at c7 l3) (at c3 l2) (at c17 l2) (at c2 l3)
	(at c0 l0) (at c6 l1) (at c11 l0) (at c14 l2) (at c1 l1)
	(at c19 l3) (at c5 l3) (at c18 l0) (at c15 l2) (at c4 l1)
	  )
  (:goal (and 
	(at c7 l1) (at c2 l3) (at c1 l2) (at c10 l0) (at c11 l1)
	(at c12 l2) (at c0 l3) (at c15 l0) (at c8 l3) (at c17 l0)
	(at c4 l2) (at c3 l1) (at c13 l1) (at c14 l2) (at c16 l3)
	(at c18 l0) (at c19 l3) (at c9 l2) (at c6 l1) (at c5 l0)
	  )
  )
)