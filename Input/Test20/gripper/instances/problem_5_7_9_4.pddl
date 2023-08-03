(define (problem problem_5_7_9_4)
(:domain gripper-strips)
(:objects 
robot1 robot2 robot3 robot4 robot5 - robot
lgripper1 lgripper2 lgripper3 lgripper4 lgripper5 rgripper1 rgripper2 rgripper3 rgripper4 rgripper5 - gripper
room1 room2 room3 room4 room5 room6 room7 - room
ball1 ball2 ball3 ball4 ball5 ball6 ball7 ball8 ball9 - object )

(:init
(at-robby robot1 room3)
(free robot1 lgripper1)
(free robot1 rgripper1)
(at-robby robot2 room5)
(free robot2 lgripper2)
(free robot2 rgripper2)
(at-robby robot3 room3)
(free robot3 lgripper3)
(free robot3 rgripper3)
(at-robby robot4 room7)
(free robot4 lgripper4)
(free robot4 rgripper4)
(at-robby robot5 room2)
(free robot5 lgripper5)
(free robot5 rgripper5)
(at ball1 room7)
(at ball2 room6)
(at ball3 room4)
(at ball4 room3)
(at ball5 room3)
(at ball6 room4)
(at ball7 room3)
(at ball8 room7)
(at ball9 room5)
)

(:goal (and
(at ball1 room7)
(at ball2 room1)
(at ball3 room5)
(at ball4 room5)
(at ball5 room6)
(at ball6 room2)
(at ball7 room6)
(at ball8 room1)
(at ball9 room1)
)
)
)