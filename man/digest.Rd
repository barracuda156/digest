\name{digest}
\alias{digest}
\title{Create hash function digests for arbitrary R objects or files}
\description{
  The \code{digest} function applies one of several cryptographic or
  non-cryptographics hash function to arbitrary R objects or files.  By
  default, the objects are internally serialized, and the selected hash
  functions algorithms can be used to compute a compact digest of the
  serialized object.

  In order to compare this implementation with others, serialization of
  the input argument can also be turned off in which the input argument
  must be a character string for which its digest is returned.
}
\usage{
digest(object, algo=c("md5", "sha1", "crc32", "sha256", "sha512",
                      "xxhash32", "xxhash64", "murmur32", "spookyhash",
                      "blake3", "crc32c", "xxh3_64", "xxh3_128"),
       serialize=TRUE, file=FALSE,
       length=Inf, skip="auto", ascii=FALSE, raw=FALSE, seed=0,
       errormode=c("stop","warn","silent"),
       serializeVersion=.getSerializeVersion())
}
\arguments{
  \item{object}{An arbitrary R object which will then be passed to the
    \code{\link{serialize}} function, unless the \code{serialize}
    argument is set to \code{FALSE}.}
  \item{algo}{The algorithms to be used; currently available choices are
    \code{md5}, which is also the default, \code{sha1}, \code{crc32},
    \code{sha256}, \code{sha512}, \code{xxhash32}, \code{xxhash64},
    \code{murmur32}, \code{spookyhash}, \code{blake3}, \code{crc32c},
    \code{xxh3_64}, and \code{xxh3_128}.}
  \item{serialize}{A logical variable indicating whether the object
    should be serialized using \code{serialize} (in ASCII
    form). Setting this to \code{FALSE} allows to compare the digest
    output of given character strings to known control output. It also
    allows the use of raw vectors such as the output of non-ASCII
    serialization.
  }
  \item{file}{A logical variable indicating whether the object is a file
    name or a file name if \code{object} is not specified.}
  \item{length}{Number of characters to process. By default, when
    \code{length} is set to \code{Inf}, the whole string or file is
    processed.}
  \item{skip}{Number of input bytes to skip before calculating the
    digest. Negative values are invalid and currently treated as zero.
    Special value \code{"auto"} will cause serialization header to be
    skipped if \code{serialize} is set to \code{TRUE} (the serialization
    header contains the R version number thus skipping it allows the
    comparison of hashes across platforms and some R versions).
  }
  \item{ascii}{This flag is passed to the \code{serialize} function if
    \code{serialize} is set to \code{TRUE}, determining whether the hash
    is computed on the ASCII or binary representation.}
  \item{raw}{A logical variable with a default value of FALSE, implying
    \code{digest} returns digest output as ASCII hex values. Set to TRUE
    to return \code{digest} output in raw (binary) form.}
  \item{seed}{an integer to seed the random number generator.  This is only
    used in the \code{xxhash32}, \code{xxhash64} and \code{murmur32} functions
    and can be used to generate additional hashes for the same input if
    desired.}
  \item{errormode}{A character value denoting a choice for the behaviour in
    the case of error: \sQuote{stop} aborts (and is the default value),
    \sQuote{warn} emits a warning and returns \code{NULL} and
    \sQuote{silent} suppresses the error and returns an empty string.}
  \item{serializeVersion}{An integer value specifying the internal
    version of the serialization format, with 2 being the default;
    see \code{\link{serialize}} for details. The \code{serializeVersion}
    field of \code{\link{option}} can also be used to set a different
    value.}
}
\value{
  The \code{digest} function returns a character string of a fixed
  length containing the requested digest of the supplied R object. This
  string is of length 32 for MD5; of length 40 for SHA-1; of length 8
  for CRC32 a string; of length 8 for for xxhash32; of length 16 for
  xxhash64; and of length 8 for murmur32.
}
\details{
  Cryptographic hash functions are well researched and documented. The
  MD5 algorithm by Ron Rivest is specified in RFC 1321. The SHA-1
  algorithm is specified in FIPS-180-1, SHA-2 is described in
  FIPS-180-2.

  For md5, sha-1 and sha-256, this R implementation relies on standalone
  implementations in C by Christophe Devine. For crc32, code from the
  zlib library by Jean-loup Gailly and Mark Adler is used.

  For sha-512, a standalone implementation from Aaron Gifford is used.

  For xxhash32, xxhash64, xxh3_64 and xxh3_128 the reference implementation
  by Yann Collet is used.

  For murmur32, the progressive implementation by Shane Day is used.

  For spookyhash, the original source code by Bob Jenkins is used. The R implementation
  that integrates R's serialization directly with the algorithm allowing for
  memory-efficient incremental calculation of the hash is by Gabe Becker.

  For blake3, the C implementation by Samuel Neves and Jack O'Connor is used.

  For crc32c, the portable (i.e. non-hardware accelerated) version from
  Google is used.

  Please note that this package is not meant to be used for
  cryptographic purposes for which more comprehensive (and widely
  tested) libraries such as OpenSSL should be used. Also, it is known
  that crc32 is not collision-proof. For sha-1, recent results indicate
  certain cryptographic weaknesses as well. For more details, see for example
  \url{https://www.schneier.com/blog/archives/2005/02/cryptanalysis_o.html}.
}
\section{Change Management}{
  Version 0.6.16 of digest corrects an error in which \code{crc32} was not
  guaranteeing an eight-character return. We now pad with zero to always
  return eight characters. Should the previous behaviour be required,
  set \code{option("digestOldCRC32Format"=TRUE)} and the output will be
  consistent with prior version (but not be consistently eight characters).
}
\references{
  MD5: \url{https://www.ietf.org/rfc/rfc1321.txt}.

  SHA-1: \url{https://en.wikipedia.org/wiki/SHA-1}.
  SHA-256: \url{https://csrc.nist.gov/publications/fips/fips180-2/fips180-2withchangenotice.pdf}.
  CRC32:  The original reference webpage at \code{rocksoft.com} has
  vanished from the web; see
  \url{https://en.wikipedia.org/wiki/Cyclic_redundancy_check} for
  general information on CRC algorithms.

  \url{https://aarongifford.com/computers/sha.html} for the
  integrated C implementation of sha-512.

  The page for the code underlying the C functions used here for sha-1
  and md5, and further references, is no longer accessible.  Please see
  \url{https://en.wikipedia.org/wiki/SHA-1} and
  \url{https://en.wikipedia.org/wiki/MD5}.

  \url{https://zlib.net} for documentation on the zlib library which
  supplied the code for crc32.

  \url{https://en.wikipedia.org/wiki/SHA_hash_functions} for
  documentation on the sha functions.

  \url{https://github.com/Cyan4973/xxHash} for documentation on the xxHash
  functions.

  \url{https://github.com/aappleby/smhasher} for documentation on MurmurHash.

  \url{https://burtleburtle.net/bob/hash/spooky.html} for the original source code of SpookyHash.

  \url{https://github.com/BLAKE3-team/BLAKE3/} for the original source code of blake3.

  \url{https://github.com/google/crc32c} for the (non-hardware-accelerated) crc32c code.
}
\author{Dirk Eddelbuettel \email{edd@debian.org} for the \R interface;
  Antoine Lucas for the integration of crc32; Jarek Tuszynski for the
  file-based operations; Henrik Bengtsson and Simon Urbanek for improved
  serialization patches; Christophe Devine for the hash function
  implementations for sha-1, sha-256 and md5; Jean-loup Gailly and Mark Adler
  for crc32; Hannes Muehleisen for the integration of sha-512; Jim Hester for
  the integration of xxhash32, xxhash64 and murmur32; Kendon Bell for
  the integration of spookyhash using Gabe Becker's R package fastdigest.}
\seealso{\code{\link{serialize}}, \code{\link{md5sum}}}

\examples{

## Standard RFC 1321 test vectors
md5Input <-
  c("",
    "a",
    "abc",
    "message digest",
    "abcdefghijklmnopqrstuvwxyz",
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
    paste("12345678901234567890123456789012345678901234567890123456789012",
          "345678901234567890", sep=""))
md5Output <-
  c("d41d8cd98f00b204e9800998ecf8427e",
    "0cc175b9c0f1b6a831c399e269772661",
    "900150983cd24fb0d6963f7d28e17f72",
    "f96b697d7cb7938d525a2f31aaf161d0",
    "c3fcd3d76192e4007dfb496cca67e13b",
    "d174ab98d277d9f5a5611c2c9f419d9f",
    "57edf4a22be3c955ac49da2e2107b67a")

for (i in seq(along=md5Input)) {
  md5 <- digest(md5Input[i], serialize=FALSE)
  stopifnot(identical(md5, md5Output[i]))
}

sha1Input <-
  c("abc", "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
sha1Output <-
  c("a9993e364706816aba3e25717850c26c9cd0d89d",
    "84983e441c3bd26ebaae4aa1f95129e5e54670f1")

for (i in seq(along=sha1Input)) {
  sha1 <- digest(sha1Input[i], algo="sha1", serialize=FALSE)
  stopifnot(identical(sha1, sha1Output[i]))
}

crc32Input <-
  c("abc",
    "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
crc32Output <-
  c("352441c2",
    "171a3f5f")

for (i in seq(along=crc32Input)) {
  crc32 <- digest(crc32Input[i], algo="crc32", serialize=FALSE)
  stopifnot(identical(crc32, crc32Output[i]))
}


sha256Input <-
  c("abc",
    "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
sha256Output <-
  c("ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
    "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1")

for (i in seq(along=sha256Input)) {
  sha256 <- digest(sha256Input[i], algo="sha256", serialize=FALSE)
  stopifnot(identical(sha256, sha256Output[i]))
}

# SHA 512 example
sha512Input <-
  c("abc",
    "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
sha512Output <-
  c(paste("ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a",
          "2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f",
          sep=""),
    paste("204a8fc6dda82f0a0ced7beb8e08a41657c16ef468b228a8279be331a703c335",
          "96fd15c13b1b07f9aa1d3bea57789ca031ad85c7a71dd70354ec631238ca3445",
          sep=""))

for (i in seq(along=sha512Input)) {
  sha512 <- digest(sha512Input[i], algo="sha512", serialize=FALSE)
  stopifnot(identical(sha512, sha512Output[i]))
}

## xxhash32 example
xxhash32Input <-
    c("abc",
      "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
      "")
xxhash32Output <-
    c("32d153ff",
      "89ea60c3",
      "02cc5d05")

for (i in seq(along=xxhash32Input)) {
    xxhash32 <- digest(xxhash32Input[i], algo="xxhash32", serialize=FALSE)
    cat(xxhash32, "\n")
    stopifnot(identical(xxhash32, xxhash32Output[i]))
}

## xxhash64 example
xxhash64Input <-
    c("abc",
      "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
      "")
xxhash64Output <-
    c("44bc2cf5ad770999",
      "f06103773e8585df",
      "ef46db3751d8e999")

for (i in seq(along=xxhash64Input)) {
    xxhash64 <- digest(xxhash64Input[i], algo="xxhash64", serialize=FALSE)
    cat(xxhash64, "\n")
    stopifnot(identical(xxhash64, xxhash64Output[i]))
}

## these outputs were calculated using mmh3 python package
murmur32Input <-
    c("abc",
      "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
      "")
murmur32Output <-
    c("b3dd93fa",
      "ee925b90",
      "00000000")

for (i in seq(along=murmur32Input)) {
    murmur32 <- digest(murmur32Input[i], algo="murmur32", serialize=FALSE)
    cat(murmur32, "\n")
    stopifnot(identical(murmur32, murmur32Output[i]))
}

## these outputs were calculated using spooky python package
spookyInput <-
    c("a",
      "abc",
      "message digest")
spookyOutput <-
    c("bdc9bba09181101a922a4161f0584275",
      "67c93775f715ab8ab01178caf86713c6",
      "9630c2a55c0987a0db44434f9d67a192")

for (i in seq(along=spookyInput)) {
    # skip = 30 skips the serialization header and just hashes the strings
    spooky <- digest(spookyInput[i], algo="spookyhash", skip = 30)
    cat(spooky, "\n")
    ## we can only compare to reference output on little-endian systems
    if (isTRUE(.Call(digest:::is_little_endian)))
        stopifnot(identical(spooky, spookyOutput[i]))
}

## blake3 example
blake3Input <-
    c("abc",
      "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
      "")
blake3Output <-
    c("6437b3ac38465133ffb63b75273a8db548c558465d79db03fd359c6cd5bd9d85",
      "c19012cc2aaf0dc3d8e5c45a1b79114d2df42abb2a410bf54be09e891af06ff8",
      "af1349b9f5f9a1a6a0404dea36dcc9499bcb25c9adc112b7cc9a93cae41f3262")

for (i in seq(along=blake3Input)) {
    blake3 <- digest(blake3Input[i], algo="blake3", serialize=FALSE)
    cat(blake3, "\n")
    stopifnot(identical(blake3, blake3Output[i]))
}

## crc32c
crc32cInput <- c("123456789", "The quick brown fox jumps over the lazy dog")
crc32cOutput <- c("e3069283", "22620404")
for (i in seq_along(crc32cInput)) {
    crc32c <- digest(crc32cInput[i], algo="crc32c", serialize=FALSE)
    cat(crc32c, "\n")
    stopifnot(identical(crc32c, crc32cOutput[i]))
}

# example of a digest of a standard R list structure
digest(list(LETTERS, data.frame(a=letters[1:5], b=matrix(1:10,ncol=2))))

# test 'length' parameter and file input
fname <- file.path(R.home(),"COPYING")
x <- readChar(fname, file.info(fname)$size) # read file
for (alg in c("sha1", "md5", "crc32")) {
  # partial file
  h1 <- digest(x    , length=18000, algo=alg, serialize=FALSE)
  h2 <- digest(fname, length=18000, algo=alg, serialize=FALSE, file=TRUE)
  h3 <- digest( substr(x,1,18000) , algo=alg, serialize=FALSE)
  stopifnot( identical(h1,h2), identical(h1,h3) )
  # whole file
  h1 <- digest(x    , algo=alg, serialize=FALSE)
  h2 <- digest(fname, algo=alg, serialize=FALSE, file=TRUE)
  stopifnot( identical(h1,h2) )
}

# compare md5 algorithm to other tools
library(tools)
fname <- file.path(R.home(),"COPYING")
h1 <- as.character(md5sum(fname))
h2 <- digest(fname, algo="md5", file=TRUE)
stopifnot( identical(h1,h2) )

## digest is _designed_ to return one has summary per object to for a desired
## For vectorised output see digest::getVDigest() which provides
## better performance than base::Vectorize()

md5 <- getVDigest()
v <- md5(1:5)     			# digest integers 1 to 5
stopifnot(identical(v[1], digest(1L)),	# check first and third result
          identical(v[3], digest(3L)))

}
\keyword{misc}
