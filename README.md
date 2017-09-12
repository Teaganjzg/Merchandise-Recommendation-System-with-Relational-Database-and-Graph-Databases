# Merchandise Recommendation System with Relational Database and Graph Databases
Merchandise Recommendation System is a kind of information filtering system that can predict which merchandises users may need or purchase in future and recommend those merchandises to users. In this project, we implement a Merchandise Recommendation System by using three distinct databases: relational database(clustered and unclustered), Neo4j and OrientDB. The data we use is found online which is a sales records of an online retailer during the whole 2011. After the implementation, we compare the performance of those three databases.
## Table of Contents
* [Introduction](#intro)
* [Implementation](#implem)
* [Results](#result)
* [Credits](#credits)
* [Contact](#contact)
## <a name="intro">Introduction</a>
* Merchandise Recommendation System
The recommendation bases on the association between items. According to the previous recommendation research, without the item review scores, we create the associations between every two items of all items per customer purchase per day (using the same invoice number). 
* Relational database and Graph databases
According to the paper “XGDBench: A benchmarking platform for graph stores in exascale clouds” published in Cloud Computing Technology and Science (CloudCom), 2012 IEEE 4th International Conference, the performance of OrientDB is better than Neo4j on workload that return all neighbor vertices and their attributes of a vertex V. However, they only used a large amount of data to test the performance and they only test one depth of neighbor vertices of the root vertex. So we don’t know whether the performance changed for small data or deeper depth of neighbor vertices. In our project, we test those conditions for both Neo4j and OrientDB and analyse the result.
The performance measures **data storage**, **data import time**, **execution time**, **records of recommendation returned** and **recommendation depth**. the recommendation depth indicates what level is the recommendation at, for example, there is an association like A--B--C, then product C is the second depth recommendation of product A. After the comparison, we show the result and make an analysis why we get that result.
## <a name="implem">Implementation</a>
* Raw Data

[Online Retail Data Set](https://archive.ics.uci.edu/ml/datasets/Online+Retail)
## <a name="results">Results</a>
## <a name="credits">Credits</a>
## <a name="credits">Contact</a>
