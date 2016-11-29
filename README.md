# BignumGMP
A Swift wrapper around the GNU Multiple Precision Arithmetic Library ([libgmp](https://gmplib.org/)), largely compatible with the OpenSSL-based [Swift big number library](https://github.com/Bouke/Bignum).

## Limitations

At the moment, only a small number of `BigInt` operations corresponding to the [libgmp](https://gmplib.org/) `mpz` type are implemented. 