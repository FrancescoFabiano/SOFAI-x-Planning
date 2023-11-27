; Optimality lenght is (:optlen 56)
; Solution is (:solution fuelup r0 l0,load c1 r0 l0,fly r0 l0 l2,unload c1 r0 l2,fuelup r0 l2,load c4 r0 l2,fly r0 l2 l1,unload c4 r0 l1,fuelup r0 l1,load c10 r0 l1,fly r0 l1 l0,unload c10 r0 l0,fuelup r1 l0,load c8 r1 l0,fly r1 l0 l1,unload c8 r1 l1,fuelup r1 l1,load c12 r1 l1,fly r1 l1 l2,unload c12 r1 l2,fuelup r1 l2,load c9 r1 l2,fly r1 l2 l3,unload c9 r1 l3,fuelup r1 l3,load c3 r1 l3,fly r1 l3 l0,unload c3 r1 l0,fuelup r2 l0,load c11 r2 l0,fly r2 l0 l1,unload c11 r2 l1,fuelup r2 l1,load c17 r2 l1,fly r2 l1 l0,unload c17 r2 l0,fuelup r3 l2,load c5 r3 l2,fly r3 l2 l1,unload c5 r3 l1,fuelup r3 l1,load c19 r3 l1,fly r3 l1 l3,unload c19 r3 l3,fuelup r3 l3,load c0 r3 l3,fly r3 l3 l2,unload c0 r3 l2,fuelup r4 l3,load c18 r4 l3,fly r4 l3 l2,unload c18 r4 l2,fuelup r4 l2,load c13 r4 l2,fly r4 l2 l3,unload c13 r4 l3)
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
	(at r0 l0) (at r1 l0) (at r2 l0) (at r3 l2) (at r4 l3)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3) (rocket r4)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3) (cargo c4)
	(cargo c5) (cargo c6) (cargo c7) (cargo c8) (cargo c9)
	(cargo c10) (cargo c11) (cargo c12) (cargo c13) (cargo c14)
	(cargo c15) (cargo c16) (cargo c17) (cargo c18) (cargo c19)
	(location l0) (location l1) (location l2) (location l3) 
	(at c6 l0) (at c19 l1) (at c18 l3) (at c13 l2) (at c1 l0)
	(at c17 l1) (at c15 l3) (at c5 l2) (at c0 l3) (at c10 l1)
	(at c14 l2) (at c11 l0) (at c4 l2) (at c12 l1) (at c8 l0)
	(at c7 l3) (at c3 l3) (at c2 l0) (at c9 l2) (at c16 l1)
	  )
  (:goal (and 
	(at c14 l2) (at c3 l0) (at c5 l1) (at c15 l3) (at c8 l1)
	(at c1 l2) (at c10 l0) (at c7 l3) (at c11 l1) (at c19 l3)
	(at c2 l0) (at c18 l2) (at c17 l0) (at c4 l1) (at c0 l2)
	(at c13 l3) (at c9 l3) (at c16 l1) (at c12 l2) (at c6 l0)
	  )
  )
)
