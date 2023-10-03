; Optimality lenght is (:optlen 8)

(define (problem problem_4_2_2_43)
(:domain gripper-strips)
(:objects 
robot1 robot2 - robot
lgripper1 lgripper2 rgripper1 rgripper2 - gripper
room1 room2 - room
ball1 ball2 ball3 ball4 - object )

(:init
(at-robby robot1 room1)
(free robot1 lgripper1)
(free robot1 rgripper1)
(at-robby robot2 room1)
(free robot2 lgripper2)
(free robot2 rgripper2)
(at ball1 room2)
(at ball2 room1)
(at ball3 room2)
(at ball4 room2)
)

(:goal (and
(at ball1 room1)
(at ball2 room2)
(at ball3 room1)
(at ball4 room2)
)
)
)

