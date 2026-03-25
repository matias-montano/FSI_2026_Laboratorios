## nivel de confianza

unknown: you don’t know how good they are at validating others’ keys. This is the default for keys you import.
none: you know they sign other keys improperly.
marginal: you think they understand signing and validate properly.
full: their judgment in signing others’ keys is as good as yours.

## tamano bits

Genera la **clave privada** (2048 o 3072 bits; 3072 está bien):

```sh
openssl genpkey -algorithm RSA -out grupo03-private.key -pkeyopt rsa_keygen_bits:3072
```
