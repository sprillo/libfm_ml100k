##### Input: lee de ml-100k los archivos u1.base, u1.test, u.user y u.item
##### Output: genera los archivos ml_train y ml_test en el directorio datasets - son las versiones libfm de u1.base y u1.test respectivamente.
##### Parametros:
categorical_features = c("movie_id"
                         ,"user_id"
                         ,"age"
                         ,"gender"
                         ,"occupation"
                         ,"Action"
                         ,"Adventure"
                         ,"Animation"
                         ,"Childrens"
                         ,"Comedy"
                         ,"Crime"
                         ,"Documentary"
                         ,"Drama"
                         ,"Fantasy"
                         ,"Film-Noir"
                         ,"Horror"
                         ,"Musical"
                         ,"Mystery"
                         ,"Romance"
                         ,"Sci-Fi"
                         ,"Thriller"
                         ,"War"
                         ,"Western"
)
# Son los features a utilizar
# NOTA: solo se banca features categoricos

##### Codigo:

users = read.table("ml-100k/u.user",sep = "|",header = FALSE)
items = read.table("ml-100k/u.item",sep="|",quote="",header = FALSE)
ratings_train = read.table("ml-100k/u1.base",sep = "\t",header = FALSE)
ratings_test = read.table("ml-100k/u1.test",sep = "\t",header = FALSE)

colnames(users) = c("user_id","age","gender","occupation","zip_code")
colnames(items) = c("movie_id","movie_title","release_date","video_release_date","IMDb_URL","unknown","Action","Adventure","Animation","Childrens","Comedy","Crime","Documentary","Drama","Fantasy","Film-Noir","Horror","Musical","Mystery","Romance","Sci-Fi","Thriller","War","Western")
colnames(ratings_train) = c("user_id","movie_id","rating","timestamp")
colnames(ratings_test) = c("user_id","movie_id","rating","timestamp")

add_metadata_to_ratings = function(ratings,users,items){
  res = merge(ratings,users)
  res = merge(res,items)
  return(res)
}

all_train = add_metadata_to_ratings(ratings_train,users,items)
all_test = add_metadata_to_ratings(ratings_test,users,items)
all = rbind(all_train,all_test)
colnames(all)
# all$rating = -all$rating # Para dar vuelta los ratings. FM andaria mejor!

stopifnot(all(categorical_features %in% colnames(all)))

all = all[,c(categorical_features,"rating")]

for(categorical_feature in categorical_features){
  all[,c(categorical_feature)] = as.integer(as.factor(all[,c(categorical_feature)]))
}

str(all)

write.csv(all,"intermediateDataFrames/all",quote = FALSE,row.names = FALSE)

all = read.table("intermediateDataFrames/all",sep = ",",header = TRUE,quote = "")

offset <- 0
for(i in 1:(ncol(all)-1)){
  if(i >= 2){
    offset = offset + length(unique(all[,i - 1]))
  }
  all[,i] = all[,i] + offset - 1
}
write.csv(all,"intermediateDataFrames/all_onehot.csv",row.names = FALSE,quote = FALSE)

all = read.csv("intermediateDataFrames/all_onehot.csv")
train = all[1:80000,]
test = all[80001:100000,]
set.seed(2)
train = train[sample(nrow(train),nrow(train)),]
set.seed(2)
test = test[sample(nrow(test),nrow(test)),]
write.csv(train,"intermediateDataFrames/ml_train.csv",row.names = FALSE,quote = FALSE)
write.csv(test,"intermediateDataFrames/ml_test.csv",row.names = FALSE,quote = FALSE)

filenames = c("ml_train.csv"
              ,"ml_test.csv")
myFunc = function(x){
  return(sapply(x,FUN = function(i){paste0(i,":1")}))
}
for(filename in filenames){
  df = read.csv(paste0("intermediateDataFrames/",filename),header = TRUE)
  df2 = cbind(df[,ncol(df)],sapply(df[,c(-ncol(df))],myFunc))
  write.table(df2,paste0("datasets/",substr(filename,1,nchar(filename)-4)),row.names = FALSE,quote = FALSE,col.names = FALSE,sep = " ")
}


filenames = c("intermediateDataFrames/ml_train.csv"
              ,"intermediateDataFrames/ml_test.csv")

df1 = read.csv(filenames[1],header = TRUE)
df2 = read.csv(filenames[2],header = TRUE)
df = rbind(df1,df2)
mins = apply(df,MARGIN = 2,FUN = min)
maxes = apply(df, MARGIN = 2, FUN = max)
stopifnot(mins[1] == 0)
for(i in 1:(ncol(df) - 2)){
  stopifnot(maxes[i] + 1 == mins[i + 1])
}
