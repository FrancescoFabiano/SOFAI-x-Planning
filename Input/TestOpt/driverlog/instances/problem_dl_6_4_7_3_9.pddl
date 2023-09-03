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
	p0-5 - location
	p1-2 - location
	p1-4 - location
	p2-3 - location
	p2-5 - location
	p3-0 - location
	p3-1 - location
	p5-1 - location
	)
	(:init
	(at driver1 s3)
	(at driver2 s2)
	(at driver3 s0)
	(at driver4 s2)
	(at truck1 s3)
	(empty truck1)
	(at truck2 s3)
	(empty truck2)
	(at truck3 s2)
	(empty truck3)
	(at package1 s3)
	(at package2 s0)
	(at package3 s0)
	(at package4 s1)
	(at package5 s3)
	(at package6 s2)
	(at package7 s4)
	(path s0 p0-5)
	(path p0-5 s0)
	(path s5 p0-5)
	(path p0-5 s5)
	(path s1 p1-2)
	(path p1-2 s1)
	(path s2 p1-2)
	(path p1-2 s2)
	(path s1 p1-4)
	(path p1-4 s1)
	(path s4 p1-4)
	(path p1-4 s4)
	(path s2 p2-3)
	(path p2-3 s2)
	(path s3 p2-3)
	(path p2-3 s3)
	(path s2 p2-5)
	(path p2-5 s2)
	(path s5 p2-5)
	(path p2-5 s5)
	(path s3 p3-0)
	(path p3-0 s3)
	(path s0 p3-0)
	(path p3-0 s0)
	(path s3 p3-1)
	(path p3-1 s3)
	(path s1 p3-1)
	(path p3-1 s1)
	(path s5 p5-1)
	(path p5-1 s5)
	(path s1 p5-1)
	(path p5-1 s1)
	(link s0 s1)
	(link s1 s0)
	(link s0 s3)
	(link s3 s0)
	(link s0 s4)
	(link s4 s0)
	(link s0 s5)
	(link s5 s0)
	(link s1 s5)
	(link s5 s1)
	(link s2 s0)
	(link s0 s2)
	(link s4 s1)
	(link s1 s4)
	(link s4 s2)
	(link s2 s4)
	(link s4 s3)
	(link s3 s4)
	(link s4 s5)
	(link s5 s4)
	(link s5 s2)
	(link s2 s5)
	(link s5 s3)
	(link s3 s5)
)
	(:goal (and
	(at driver1 s2)
	(at driver2 s5)
	(at driver3 s2)
	(at truck1 s0)
	(at truck2 s4)
	(at package1 s1)
	(at package2 s0)
	(at package3 s5)
	(at package4 s2)
	(at package5 s5)
	(at package6 s5)
	(at package7 s1)
	))


)
