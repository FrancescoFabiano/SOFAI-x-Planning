(define (problem problem_3_5_9_3)
(:domain gripper-strips)
(:objects 
robot1 robot2 robot3 - robot
lgripper1 lgripper2 lgripper3 rgripper1 rgripper2 rgripper3 - gripper
room1 room2 room3 room4 room5 - room
ball1 ball2 ball3 ball4 ball5 ball6 ball7 ball8 ball9 - object )

(:init
(at-robby robot1 room3)
(free robot1 lgripper1)
(free robot1 rgripper1)
(at-robby robot2 room1)
(free robot2 lgripper2)
(free robot2 rgripper2)
(at-robby robot3 room3)
(free robot3 lgripper3)
(free robot3 rgripper3)
(at ball1 room5)
(at ball2 room5)
(at ball3 room4)
(at ball4 room5)
(at ball5 room3)
(at ball6 room5)
(at ball7 room2)
(at ball8 room3)
(at ball9 room5)
)

(:goal (and
(at ball1 room5)
(at ball2 room5)
(at ball3 room4)
(at ball4 room3)
(at ball5 room1)
(at ball6 room2)
(at ball7 room4)
(at ball8 room3)
(at ball9 room4)
)
)
)
