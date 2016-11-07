HDS <- read.delim("W:/Patterson/Data/Raw Data/Dimensions/HDSData.txt",sep="|",header = T)

Rel <- read.csv("W:/Patterson/Data/Data Changes/Hierarchies/MasterCustomerToSubCustomerRelationship.csv")

Addr <- Rel[c(4,11:21)]

CustNum <- dplyr::distinct(Cust[c(1)])

HDSCustNum <- dplyr::distinct(HDS[c(3)])

CustnHDSNumJoin <- sqldf::sqldf("select A.*,B.* from CustNum as A LEFT JOIN HDSCustNum as B
                                ON A.CUSTOMER_NUMBER=B.Customer_Number")

NoMatch <- dplyr::distinct(CustnHDSNumJoin[is.na(CustnHDSNumJoin$Customer_Number),])

CustNoMatch <- dplyr::distinct(NoMatch[c(1)])

HDS_Add <- HDS[c(19:31)]

Add_Matches_a <- sqldf::sqldf("select A.CUSTOMER_NUMBER,A.ZIP_5_KEY,A.ShipTo_ADDR_PHONE,A.ShipTo_ADDR_NAME,A.ShipTo_ADDR1,
                              A.ShipTo_ADDR2, B.HDS_Mail_Address,B.HDS_Zip,B.HDS_Mail_Zip,B.HDS_Phone 
                              from Addr as A LEFT JOIN HDS_Add as B
                              ON A.ZIP_5_KEY=B.HDS_Zip and A.ShipTo_ADDR_PHONE=B.HDS_Phone")


Add_Matches1a <- dplyr::distinct(Add_Matches_a[!is.na(Add_Matches_a$HDS_Mail_Zip),])

NoMatch1a <- plyr::rename(NoMatch,c("CUSTOMER_NUMBER"="Cust"))

Add_Matches2a <- sqldf::sqldf("select A.Cust , B.*
                              from NoMatch1a as A LEFT JOIN Add_Matches1a as B ON A.Cust=B.CUSTOMER_NUMBER")

Add_Matches3a <- dplyr::distinct(Add_Matches2a[!is.na(Add_Matches2a$HDS_Mail_Zip),])

write.csv(Add_Matches3a,"W:/Patterson/Data/Data Changes/HDS Cust Match Recheck.csv",row.names = FALSE)
















