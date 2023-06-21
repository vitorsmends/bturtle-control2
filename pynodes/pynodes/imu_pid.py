import rclpy
from rclpy.node import Node
import sensor_msgs.msg
import std_msgs.msg
import geometry_msgs.msg

import math, time


class ImuPidNode(Node):

    def __init__(self):
        super().__init__('imu_custom_node')
        #self.publisherAngle = self.create_publisher(std_msgs.msg.Float32, '/rotation_angle', 10)
        self.publisherController = self.create_publisher(geometry_msgs.msg.Twist, '/cmd_vel', 10)
        timer_period = 0.005  # seconds (1/200hz = 0.005s)
        self.timer = self.create_timer(timer_period, self.publish_callback)
        self.i = 0
        self.max_vel=0.2

        self.subscription = self.create_subscription(
          sensor_msgs.msg.Imu, 
          '/imu', 
          self.listener_callback, 
          10)
        self.subscription # prevent unused variable warning
        self.quaternion=[0,0,0,0] # inicializa com valores arbitrarios
        self.euler=[0,0,0]

        self.vel_0 = 0
        self.vel_1 = 0
        self.vel_2 = 0

        self.ang_0=0
        self.ang_1=0
        self.ang_2=0

        self.kp= 0.015
        self.ki= 0.000062 #0.00003
        self.kd= 0.0010
        self.ts=0.005   # periodo de amostragem


    def listener_callback(self, data):
        """
        Callback function.
        """
        self.quaternion=[data.orientation.x, data.orientation.y, data.orientation.z, data.orientation.w]
        self.euler = self.euler_from_quaternion(data.orientation.x, data.orientation.y, data.orientation.z, data.orientation.w)
  

    def publish_callback(self):
        """
        Publish the data
        """
        self.ang_0=0+self.euler[0]
        # eq(5) from https://engineering.stackexchange.com/questions/26537/what-is-a-definitive-discrete-pid-controller-equation
        self.vel_0 = self.vel_1 + (self.kp + self.ki*self.ts/2 + self.kd/self.ts)*self.ang_0 + (-self.kp + self.ki*self.ts/2 -2*self.kd/self.ts)*self.ang_1 + (self.kd/self.ts)*self.ang_2
        print(self.vel_0)


        # limite de saturacao do motor
        if self.vel_0 > self.max_vel:
            self.vel_0=self.max_vel
        
        if self.vel_0 < -self.max_vel:
            self.vel_0=-self.max_vel

        velocity = geometry_msgs.msg.Twist()
        velocity.linear.x=self.vel_0
        
        self.publisherController.publish(velocity)

        self.vel_1 = self.vel_0
        self.ang_2=self.ang_1
        self.ang_1=self.ang_0


    def euler_from_quaternion(self, x, y, z, w):
        """
        Convert a quaternion into euler angles (roll, pitch, yaw)
        roll is rotation around x in degrees (counterclockwise)
        pitch is rotation around y in degrees (counterclockwise)
        yaw is rotation around z in degrees (counterclockwise)
        """
        t0 = +2.0 * (w * x + y * z)
        t1 = +1.0 - 2.0 * (x * x + y * y)
        roll_x = math.degrees(math.atan2(t0, t1))
     
        t2 = +2.0 * (w * y - z * x)
        t2 = +1.0 if t2 > +1.0 else t2
        t2 = -1.0 if t2 < -1.0 else t2
        pitch_y = math.degrees(math.asin(t2))
     
        t3 = +2.0 * (w * z + x * y)
        t4 = +1.0 - 2.0 * (y * y + z * z)
        yaw_z = math.degrees(math.atan2(t3, t4))
             
        return [roll_x, pitch_y, yaw_z] # in degrees


def main(args=None):
    print("Creating node ...")
    rclpy.init(args=args)

    imu_node = ImuPidNode()

    rclpy.spin(imu_node)

    # Destroy the node explicitly
    # (optional - otherwise it will be done automatically
    # when the garbage collector destroys the node object)
    imu_node.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    try:
        main()
    except:
        pass