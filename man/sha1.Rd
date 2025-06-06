\docType{methods}
\name{sha1}
\alias{sha1}
\alias{sha1_attr_digest}
\alias{sha1_digest}
\alias{sha1.array}
\alias{sha1.integer}
\alias{sha1.numeric}
\alias{sha1.character}
\alias{sha1.complex}
\alias{sha1.Date}
\alias{sha1.factor}
\alias{sha1.NULL}
\alias{sha1.logical}
\alias{sha1.matrix}
\alias{sha1.data.frame}
\alias{sha1.list}
\alias{sha1.pairlist}
\alias{sha1.name}
\alias{sha1.POSIXlt}
\alias{sha1.POSIXct}
\alias{sha1.anova}
\alias{sha1.function}
\alias{sha1.call}
\alias{sha1.raw}
\alias{sha1.formula}
\alias{sha1.(}
\alias{sha1.environment}
\alias{sha1.<-}
\title{Calculate a SHA1 hash of an object}
\author{Thierry Onkelinx}
\usage{
sha1(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
\method{sha1}{numeric}(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
\method{sha1}{complex}(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
\method{sha1}{Date}(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
\method{sha1}{matrix}(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
\method{sha1}{data.frame}(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
\method{sha1}{array}(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
\method{sha1}{list}(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
\method{sha1}{pairlist}(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
\method{sha1}{POSIXlt}(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
\method{sha1}{POSIXct}(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
\method{sha1}{anova}(x, digits = 4, zapsmall = 7, ..., algo = "sha1")
\method{sha1}{function}(x, digits = 14, zapsmall = 7, ..., algo = "sha1")

\method{sha1}{formula}(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
\method{sha1}{`(`}(...)

sha1_digest(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
\method{sha1}{NULL}(...)
\method{sha1}{name}(...)

sha1_attr_digest(x, digits = 14, zapsmall = 7, ..., algo = "sha1")
\method{sha1}{call}(...)
\method{sha1}{character}(...)
\method{sha1}{factor}(...)
\method{sha1}{integer}(...)
\method{sha1}{logical}(...)
\method{sha1}{raw}(...)
\method{sha1}{environment}(...)
\method{sha1}{`<-`}(...)
}
\arguments{
\item{x}{the object to calculate the SHA1}

\item{digits}{the approximate number of significant digits in base 10. Will
be converted to a base 16 equivalent. Defaults to \code{digits = 14}, except for
sha1.anova where \code{digits = 4}}

\item{zapsmall}{the approximate negative magnitude of the smallest relevant
digit. Will be converted to a base 2 equivalent. Values smaller than this
number are equivalent to 0. Defaults to \code{zapsmall = 7}}

\item{...}{If it is the only defined argument, passed to another \code{sha1}
method.  If other arguments exist, see Details for usage.}

\item{algo}{The hashing algorithm to be used by \code{\link{digest}}. Defaults to
"sha1"}
}
\description{
Calculate a SHA1 hash of an object. The main difference with
\code{digest(x, algo = "sha1")} is that \code{sha1()} will give the same hash on
32-bit and 64-bit systems. Note that the results depends on the setting of
\code{digits} and \code{zapsmall} when handling floating point numbers. The
current defaults keep \code{digits} and \code{zapsmall} as large as possible
while maintaining the same hash on 32 bit and 64 bit systems.
}
\details{
\code{sha1_digest()} is a convenience function for objects where attributes
cannot be added to apply the \code{digest()} function to its arguments.
\code{sha1_attr_digest()} is a convenience function for objects where objects
can be added to generate the hash.  If generating hashes for objects in other
packages, one of these two functions is recommended for use (typically,
\code{sha1_attr_digest()}).

Extra arguments:

environment: An optional extra argument for \code{sha1.function} and
\code{sha1.formula} should be TRUE, FALSE or missing. \code{sha1.function} and
\code{sha1.formula} will ignore the environment of the function only when
\code{environment = FALSE}.
}
\note{
\code{sha1} gained an \code{algo} argument since version 0.6.15. This allows
\code{sha1()} to use all hashing algorithms available in \code{digest()}. The
hashes created with \code{sha1(x)} from digest >= 0.6.15 are identical to
\code{sha1(x)} from digest <= 0.6.14. The only exceptions are hashes created
with \code{sha1(x, algo = "sha1")}, they will be different starting from digest
0.6.15

Until version 0.6.22, \code{sha1} ignored the attributes of the object for
some classes. This was fixed in version 0.6.23. Use
\code{options(sha1PackageVersion = "0.6.22")} to get the old behaviour.

Version 0.6.24 and later ignore attributes named \code{srcref}.

Version 0.6.38 and later use \code{digest()} as a fallback for undefined
methods. Note that this breaks the guarantee for identical hashes between 32-bit
and 64-bit system. We recommend to write a custom method for such class. The
basic idea is the convert the class in a list of classes that \code{sha1} can
handle. The project \url{https://github.com/inbo/n2kanalysis/} demonstrates
how to create custom \code{sha1} dispatchers for other S3 classes, see
file \url{https://github.com/inbo/n2kanalysis/blob/main/R/sha1.R}.

}
