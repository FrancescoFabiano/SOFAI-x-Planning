; Optimality lenght is (:optlen 40)
; Solution is (:solution fuelup r0 l2,load c0 r0 l2,fly r0 l2 l0,unload c0 r0 l0,fuelup r0 l0,load c11 r0 l0,fly r0 l0 l1,unload c11 r0 l1,fuelup r0 l1,load c19 r0 l1,fly r0 l1 l2,unload c19 r0 l2,fuelup r1 l2,load c6 r1 l2,fly r1 l2 l1,unload c6 r1 l1,fuelup r1 l1,load c16 r1 l1,fly r1 l1 l0,unload c16 r1 l0,fuelup r1 l0,load c1 r1 l0,fly r1 l0 l2,unload c1 r1 l2,fuelup r2 l2,load c12 r2 l2,fly r2 l2 l0,unload c12 r2 l0,fuelup r2 l0,load c18 r2 l0,fly r2 l0 l3,unload c18 r2 l3,fuelup r2 l3,load c5 r2 l3,fly r2 l3 l1,unload c5 r2 l1,fuelup r2 l1,load c10 r2 l1,fly r2 l1 l2,unload c10 r2 l2)
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
	(at r0 l2) (at r1 l2) (at r2 l2) (at r3 l3) (at r4 l1)
	
	(rocket r0) (rocket r1) (rocket r2) (rocket r3) (rocket r4)
	(cargo c0) (cargo c1) (cargo c2) (cargo c3) (cargo c4)
	(cargo c5) (cargo c6) (cargo c7) (cargo c8) (cargo c9)
	(cargo c10) (cargo c11) (cargo c12) (cargo c13) (cargo c14)
	(cargo c15) (cargo c16) (cargo c17) (cargo c18) (cargo c19)
	(location l0) (location l1) (location l2) (location l3) 
	(at c5 l3) (at c10 l1) (at c6 l2) (at c11 l0) (at c7 l3)
	(at c2 l0) (at c0 l2) (at c19 l1) (at c15 l0) (at c13 l3)
	(at c17 l2) (at c9 l1) (at c16 l1) (at c1 l0) (at c4 l3)
	(at c3 l2) (at c18 l0) (at c14 l1) (at c12 l2) (at c8 l3)
	  )
  (:goal (and 
	(at c16 l0) (at c19 l2) (at c6 l1) (at c8 l3) (at c13 l3)
	(at c17 l2) (at c15 l0) (at c5 l1) (at c0 l0) (at c18 l3)
	(at c11 l1) (at c1 l2) (at c14 l1) (at c7 l3) (at c2 l0)
	(at c10 l2) (at c3 l2) (at c12 l0) (at c9 l1) (at c4 l3)
	  )
  )
)
