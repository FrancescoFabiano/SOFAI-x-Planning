; Optimality lenght is (:optlen -1)

(define (problem DLOG-4-3-7)
	(:domain driverlog)
	(:objects
	driver1 - driver
	driver2 - driver
	driver3 - driver
	driver4 - driver
	truck1 - truck
	truck2 - truck
	truck3 - truck
	package1 - obj
	package2 - obj
	package3 - obj
	package4 - obj
	package5 - obj
	package6 - obj
	package7 - obj
	s0 - location
	s1 - location
	s2 - location
	s3 - location
	s4 - location
	s5 - location
	p0-3 - location
	p1-0 - location
	p1-2 - location
	p1-4 - location
	p2-5 - location
	p3-4 - location
	p5-1 - location
	p5-2 - location
	p5-3 - location
	p5-4 - location
	)
	(:init
	(at driver1 s5)
	(at driver2 s5)
	(at driver3 s3)
	(at driver4 s5)
	(at truck1 s3)
	(empty truck1)
	(at truck2 s4)
	(empty truck2)
	(at truck3 s2)
	(empty truck3)
	(at package1 s4)
	(at package2 s2)
	(at package3 s4)
	(at package4 s0)
	(at package5 s2)
	(at package6 s4)
	(at package7 s3)
	(path s0 p0-3)
	(path p0-3 s0)
	(path s3 p0-3)
	(path p0-3 s3)
	(path s1 p1-0)
	(path p1-0 s1)
	(path s0 p1-0)
	(path p1-0 s0)
	(path s1 p1-2)
	(path p1-2 s1)
	(path s2 p1-2)
	(path p1-2 s2)
	(path s1 p1-4)
	(path p1-4 s1)
	(path s4 p1-4)
	(path p1-4 s4)
	(path s2 p2-5)
	(path p2-5 s2)
	(path s5 p2-5)
	(path p2-5 s5)
	(path s3 p3-4)
	(path p3-4 s3)
	(path s4 p3-4)
	(path p3-4 s4)
	(path s5 p5-1)
	(path p5-1 s5)
	(path s1 p5-1)
	(path p5-1 s1)
	(path s5 p5-3)
	(path p5-3 s5)
	(path s3 p5-3)
	(path p5-3 s3)
	(path s5 p5-4)
	(path p5-4 s5)
	(path s4 p5-4)
	(path p5-4 s4)
	(link s0 s3)
	(link s3 s0)
	(link s0 s5)
	(link s5 s0)
	(link s1 s2)
	(link s2 s1)
	(link s1 s4)
	(link s4 s1)
	(link s2 s0)
	(link s0 s2)
	(link s3 s4)
	(link s4 s3)
	(link s4 s0)
	(link s0 s4)
	(link s5 s1)
	(link s1 s5)
	(link s5 s3)
	(link s3 s5)
	(link s5 s4)
	(link s4 s5)
)
	(:goal (and
	(at driver1 s3)
	(at driver2 s1)
	(at driver3 s0)
	(at driver4 s5)
	(at truck2 s2)
	(at truck3 s5)
	(at package1 s2)
	(at package2 s3)
	(at package3 s5)
	(at package4 s5)
	(at package5 s4)
	(at package6 s2)
	(at package7 s1)
	))


)
