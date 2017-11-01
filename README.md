# libfm_ml100k
Ejemplo de uso de libfm sobre ml-100k

```
git clone https://github.com/srendle/libfm
cd libfm
make
cd bin
```

ALS, user + item:
```
./libFM -task r -train ../../datasets/ml_simple_train -test ../../datasets/ml_simple_test -method als -init_stdev 0.00001 -out out.txt -iter 100 -save_model model1 -dim '1,1,4' -regular 5 -seed 1
```

ALS, all features:
```
./libFM -task r -train ../../datasets/ml_all_train -test ../../datasets/ml_all_test -method als -init_stdev 0.00001 -out out.txt -iter 100 -save_model model1 -dim '1,1,4' -regular 5 -seed 1
```

ALS, all features, reverse response variable:
```
./libFM -task r -train ../../datasets/ml_flipped_all_train -test ../../datasets/ml_flipped_all_test -method als -init_stdev 0.00001 -out out.txt -iter 100 -save_model model1 -dim '1,1,4' -regular 5 -seed 1
```

MCMC, user + item:
```
./libFM -task r -train ../../datasets/ml_simple_train -test ../../datasets/ml_simple_test -method mcmc -init_stdev 0.00001 -out out.txt -iter 1000 -dim '1,1,4' -seed 1
```

MCMC, all features:
```
./libFM -task r -train ../../datasets/ml_all_train -test ../../datasets/ml_all_test -method mcmc -init_stdev 0.00001 -out out.txt -iter 1000 -dim '1,1,4' -seed 1
```

MCMC, all features, reverse response variable:
```
./libFM -task r -train ../../datasets/ml_flipped_all_train -test ../../datasets/ml_flipped_all_test -method mcmc -init_stdev 0.00001 -out out.txt -iter 1000 -dim '1,1,4' -seed 1
```

Los datasets de entrenamiento en el formato sparse de libfm fueron generados con to-libfm.R.
