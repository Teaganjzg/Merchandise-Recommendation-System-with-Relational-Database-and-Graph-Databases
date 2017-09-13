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
According to previou research, the performance of OrientDB is better than Neo4j on workload that return all neighbor vertices and their attributes of a vertex V. However, they only used a large amount of data to test the performance and they only test one depth of neighbor vertices of the root vertex. So we don’t know whether the performance changed for small data or deeper depth of neighbor vertices. In our project, we test those conditions for both Neo4j and OrientDB and analyse the result.
The performance measures **data storage**, **data import time**, **execution time**, **records of recommendation returned** and **recommendation depth**. the recommendation depth indicates what level is the recommendation at, for example, there is an association like A--B--C, then product C is the second depth recommendation of product A. After the comparison, we show the result and make an analysis why we get that result.
## <a name="implem">Implementation</a>
* Raw Data<br />
  [Online Retail Data Set](https://archive.ics.uci.edu/ml/datasets/Online+Retail)
* SQL Server 2012<br />
  Download the .iso file from [here](https://mega.nz/#!9mgBCYaQ!qbbehFKVTtcYVk6CCe3AQ6ptYYLKc6vz-7YWssiea3Q) and launch it.
* Neo4j 3.2.3<br />
  Download the Neo4j from [here](https://neo4j.com/download/community-edition/) and install it. After launching Neo4j, a web page need to be loaded by browser to manipulate the database. 
* OrientDB 2.2.18<br />
  Download and extract OrientDB by selecting the appropriate package provided on [OrientDB download website](http://orientdb.com/orientdb/). Start the server by running the **server.bat** (Windows System) scripts located in the bin folder. Once OrientDB is running, enter the following URL in a browser window: http://localhost:2480. This is the Studio which is a web tool for Databases. 
* Data Preprocessing<br />
  1. The original data are stored as xlsx files. SQL Server 2012 Import Wizard is capable to import xls file. However, the excel(xls) file has a row limitation so we have to separate the data into multiple files then import it into SQL DB respectively. [csci5559_database.7z](https://github.com/Teaganjzg/Merchandise-Recommendation-System-with-Relational-Database-and-Graph-Databases/blob/master/csci5559_database.7z) is the database backup.<br />
  2. Execute [SQLCreateAssocaition.sql]( Merchandise-Recommendation-System-with-Relational-Database-and-Graph-Databases/SQLCreateAssociation.sql ) to create Association table.<br />
     ![image](https://user-images.githubusercontent.com/31550461/30353432-0db7412c-97e3-11e7-991a-6aae74bb55bf.png)<br />
* Data Exportion<br />
  The Association table can be exported as [972K.csv](https://github.com/Teaganjzg/Merchandise-Recommendation-System-with-Relational-Database-and-Graph-Databases/blob/master/Dataset/972K.7z)<br /> 
* Data Importion<br />
  Neo4j can import data simply through a bunch of **Cypher statements** which is very intuitive.<br />
  **Add item nodes:**

  ```
  load csv with headers from "https://github.com/Teaganjzg/Merchandise-Recommendation-System-with-Relational-Database-and-Graph-      Databases/blob/master/Dataset/DescriptionList.csv" as row
  create (n:Items)
  set n=row
  ```
   &nbsp;&nbsp;**Add Index:**<br />
  `CREATE INDEX ON :Items(Description)`<br />
   **Add relations:**
   ```
   LOAD CSV WITH HEADERS FROM "https://github.com/Teaganjzg/Merchandise-Recommendation-System-with-Relational-Database-and-Graph-Databases/blob/master/Dataset/972K_1_of_3.csv" AS row
   MERGE (n1:Items {Description: row.Description1})
   MERGE (n2:Items {Description: row.Description2})
   MERGE (n1)-[a:Association{weight:row.Association_Times}]->(n2)

   LOAD CSV WITH HEADERS FROM "https://github.com/Teaganjzg/Merchandise-Recommendation-System-with-Relational-Database-and-Graph-Databases/blob/master/Dataset/972K_2_of_3.csv" AS row
   MERGE (n1:Items {Description: row.Description1})
   MERGE (n2:Items {Description: row.Description2})
   MERGE (n1)-[a:Association{weight:row.Association_Times}]->(n2)

   LOAD CSV WITH HEADERS FROM "https://github.com/Teaganjzg/Merchandise-Recommendation-System-with-Relational-Database-and-Graph-Databases/blob/master/Dataset/972K_3_of_3.csv" AS row
   MERGE (n1:Items {Description: row.Description1})
   MERGE (n2:Items {Description: row.Description2})
   MERGE (n1)-[a:Association{weight:row.Association_Times}]->(n2)
   ```
   <br />
   
   **BFS with different depths:**
  
   Depth =1:
   ```
   match (n:Items)-[a:Association]-(p)
   where n.Description = 'ZINC TOP  2 DOOR WOODEN SHELF'
   return p.Description, a.weight
   ```
   <br />

   Depth = 2:
   ```
   match (n:Items)-[a:Association]-(p)-[b:Association]-(q)
   where n.Description = 'ZINC TOP  2 DOOR WOODEN SHELF'
   return p.Description, a.weight, q.Description, b.weight
   ```
   <br />
   

   Depth = 3:
   ```
   match (n:Items)-[a:Association]-(p)-[b:Association]-(q)-[c:Association]-(u)
   where n.Description = 'ZINC TOP  2 DOOR WOODEN SHELF'
   return distinct u.Description
   ```
   <br />

   Depth = 4:
   ```  
   match (n:Items)-[a:Association]-(p)-[b:Association]-(q)-[c:Association]-(u)-[d:Association]-(v)
   where n.Description = 'ZINC TOP  2 DOOR WOODEN SHELF' 
   return distinct p.Description, a.weight, q.Description, b.weight,u.Description, c.weight,v.Description, d.weight
   ```
   <br />
   
   Depth = 5:
   ```
   match (n:Items)-[a:Association]-(p)-[b:Association]-(q)-[c:Association]-(u)-[d:Association]-(v)-[f:Association]-(w)
   where n.Description = 'ZINC TOP  2 DOOR WOODEN SHELF'
   return distinct p.Description, a.weight, q.Description, b.weight,u.Description,  c.weight,v.Description,d.weight,w.Description,f.weight
   ```

   Return Description on depth = 2:
   ```
   match (n:Items)-[a:Association]-(p)-[b:Association]-(q)
   where n.Description = 'ZINC TOP  2 DOOR WOODEN SHELF'
   return distinct q.Description
   order by q.Description desc
   ```
 * Trouble Shooting:
    1. Neo4j:
       RESET
       ```
       START r=relationship(*) DELETE r;
       START n=node(*) DELETE n;
       ```


  
## <a name="results">Results</a>
## <a name="credits">Credits</a>
## <a name="credits">Contact</a>
