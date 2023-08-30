(define (problem problem_2_5_9_1)
(:domain gripper-strips)
(:objects 
robot1 robot2 - robot
lgripper1 lgripper2 rgripper1 rgripper2 - gripper
room1 room2 room3 room4 room5 - room
ball1 ball2 ball3 ball4 ball5 ball6 ball7 ball8 ball9 - object )

(:init
(at-robby robot1 room1)
(free robot1 lgripper1)
(free robot1 rgripper1)
(at-robby robot2 room3)
(free robot2 lgripper2)
(free robot2 rgripper2)
(at ball1 room4)
(at ball2 room2)
(at ball3 room2)
(at ball4 room4)
(at ball5 room4)
(at ball6 room4)
(at ball7 room2)
(at ball8 room3)
(at ball9 room1)
)

(:goal (and
(at ball1 room1)
(at ball2 room1)
(at ball3 room2)
(at ball4 room3)
(at ball5 room5)
(at ball6 room1)
(at ball7 room2)
(at ball8 room1)
(at ball9 room2)
)
)
)
