# Workload - Data and Analytics Transportation


### Data and Analytics Transportation sample app


The Data and Analytics Transportation app demonstrates
a data analytics workflow that uses a combination of Bluemix and open source applications to create a visualization of information.
The data is retrieved from a transportation system in Madrid, filtered and then saved in Object Storage. The information is then analyzed, and the results are presented in a Node-RED Freeboard.


## Introduction

After registering for Bluemix and DevOps Services, you can deploy the Data and Analytics Transportation app into your personal DevOps space.

## Sign up and log into Bluemix and DevOps

Sign up for Bluemix at https://console.ng.bluemix.net and DevOps Services at https://hub.jazz.net.
When you sign up, you'll create an IBM ID, create an alias, and register with Bluemix.


## Make sure a Public IP is available in your Bluemix space
 
This solution requires a free public IP. To first determine if a public IP is available we will need to find your used and max quota of IPs for your space.
To find out this information 

1. Log into your Dashboard at https://console.ng.bluemix.net.
2. Select **DASHBOARD**
3. Select the space you will deploy DAT to
4. In the **Containers** tile you will see information about your IPs
5. The **Public IPs Requested** field needs to not be at its max. 

In order to release an public IP, install the ICE CLI, which can be found at the website below.

https://www.ng.bluemix.net/docs/containers/container_cli_ov.html

Once installed:

1. Log into your Bluemix account and space.
```
ice login
```
2. List your current external IPs.
```
ice ip list
```



You need at least one available IP address. Your max amount  which can be found in your Bluemix dashboard in the Containers tile.
In order to make room for the new IP address, release an IP by using the following command:


## Deploy to Bluemix

Click the **Deploy to Bluemix** button below to deploy the source code to DevOps Services and create the needed Cloud Foundry and Container applications. This deployment creates instances of Object-Storage, Cloudant, and Spark and binds them to your application.

 [![Deploy to Bluemix](https://bluemix.net/deploy/button.png)](https://bluemix.net/deploy?repository=https://hub.jazz.net/git/cfsworkload/data-analytics-transportation)

After the pipeline has been configured, you can monitor the deployment by doing the following steps 

1. Select your newly created project in DevOps Services. 
2. Go to **MY PROJECTS**
3. Select **BUILD & DEPLOY**
4. You can monitor the stages by selecting **View logs and history**.

## Set up Object Storage

Download data schemas from the IDS project and upload them to your container. The schemas define what information Secor pulls from Kafka and allows Spark read the stored data.

1. Go to your project in DevOps Services, and download **secor/DataServices.metaKeys** and **secor/DataServices.schema** to your local machine.
2. From your Cloud Foundry's dashboard select **DAT-objectstorage**.
3. From the **Actions** drop down menu at the top left, select **Add Container** and name it **secorSchema**.
4. Create another container and name it **DataServices**.
5. Select your **secorSchema** container, and from the **Actions** drop down menu, select **Add File**

	-  Select the **DataServices.metaKeys** file you downloaded to your local machine.
	-  Select the **DataServices.metaKeys** file you downloaded to your local machine.


## Add your Object Storage and IPython notebook to Spark

To get spark set working we need to link our Object Storage and IPython notebook, which contains our script to process the data from Object Storage. ** Needs update **

1. In DevOps Services, select your project and download **dat_notebook.ipynb** to your local machine.
2. Inside the **Spark** service, click **Open** at the top right.
3. Select your newly created **DAT-spark** instance.
4. At the top select **Object Storage** and select **ADD OBJECT STORAGE**.
5. Select **Bluemix** at the top.
6. Select **DAT-objectstorage** from the options. Select the container **DataServices** and press **SELECT**.
7. Click **My Notebooks** at the top and select **New Notebook**.
8. Select **From File** at the top. Name the notebook and give it a description.
9. Click on **Choose File** and select the **dat_notebook.ipynb** downloaded to your local machine.
10. Select **Create Notebook**.

Spark is now ready to be run, but first we need to put our container's public IP into Node-RED

## Set up your external IP with Node-RED

Add the external IP address of your container to Node-RED.

1. Obtain the public IP of your DAT-container on the container's tile at your Bluemix Dashboard
1. Return to your Cloud Foundry's application dashboard and select the route for your application to access Node-RED.
2. Click **Go to your Node-RED flow editor**. You will see the customized flow. 
3. Connect the initial **Every 5 minutes** node to the **Get traffic status from Madrid** node.
4. Double click on the **Send to Kafka** node at the far right to edit the Kafka producer node. Click the **pencil** icon to edit the DAT Kafka Zookeeper Server.
5. In the **Edit kafka-credentials config node** window, modify the **Zookeeper Server Address** field to the public IP address of DAT-container_<number>
6. Press **Update**.
7. Click **OK** to close the window.
8. Click **Deploy** in the upper right to deploy the updated flow to Node-RED.


#### Start the Apache Spark script

1. Go to the project in your Dashboard, and choose **Apache Spark**.
2. Click **OPEN** and select your Apache Spark instance.
3. Click on the notebook you created.
4. In the script, update **0.0.0.0** to your container's public IP address.
5. Click **Play** at the top.


## Access Freeboard from Node-RED

Once data is processed, you will be able to see a visual representation of real-time traffic information displayed in a Node-RED Freeboard. The information on the Freeboard is collected from three separate areas of Madrid and the three data points are simultaneously displayed. You are able to see the live feed from traffic cameras, as well as, the speed and intensity of traffic and their analyzed thresholds.

1. Return to your Cloud Foundry's application dashboard and select the route for your application to access Node-RED.
2. Click **Go to your Freeboard dashboard** to load your newly configured Freeboard.

  ![EXAMPLE](images/loaded_freeboard.png)

## Reference

The Data and Analytics Transportation sample app combines several different Bluemix and open source applications.

##### Open source

Apache Kafka: a message hub that provides a commit log of updates.

Secor: a reliable logging service that takes information from Kafka and converts it into parquet files. Those files are then placed into Object Storage within Bluemix.

##### Bluemix

Apache Spark: a data processing engine.

IPython: an interactive computational environment where you can combine coding, text, math, and media.

Node-RED: a tool for wiring together the Internet of Things.

Node-RED Freeboard: a data visualization dashboard.

Object Storage: uses unique ID's and containers to store information in a scalable way.
