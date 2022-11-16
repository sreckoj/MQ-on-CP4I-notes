
# IBM MQ - Multi-instance



## Create a multi-instance queue manager using the Platform Navigator

Navigate to Integration instances and click on Create an instance

<img width="850" src="images/Snip20221116_92.png">

Select **Messaging**, click Next

<img width="850" src="images/Snip20221116_93.png">

and then select one of the provided options, for example, *Quick start*:

<img width="850" src="images/Snip20221116_94.png">

Enter the name, select the namespace and accept the license:

<img width="850" src="images/Snip20221116_95.png">

Scroll down. Select **MultiInstance** for the type of availability, the storage class of the **RWX** type (in our example it is *rook-cephfs*), and select **persistent-claim** for the type of volume. Leave default values for other properties and click on **Create**:

<img width="850" src="images/Snip20221116_97.png">



