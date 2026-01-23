enum EHttpStatus {
  // region 100
  continueRequest(100),
  switchingProtocols(101),
  processing(102),
  earlyHints(103),
  // endregion

  // region 200
  ok(200),
  created(201),
  accepted(202),
  nonAuthoritativeInformation(203),
  noContent(204),
  resetContent(205),
  partialContent(206),
  multiStatus(207),
  alreadyReported(208),
  imUsed(226),
  // endregion

  // region 300
  multipleChoices(300),
  movedPermanently(301),
  found(302),
  seeOther(303),
  notModified(304),
  useProxy(305),
  temporaryRedirect(307),
  permanentRedirect(308),
  // endregion

  // region 400
  badRequest(400),
  unauthorized(401),
  paymentRequired(402),
  forbidden(403),
  notFound(404),
  methodNotAllowed(405),
  notAcceptable(406),
  proxyAuthenticationRequired(407),
  requestTimeout(408),
  conflict(409),
  gone(410),
  lengthRequired(411),
  payloadTooLarge(413),
  uriTooLong(414),
  unsupportedMediaType(415),
  rangeNotSatisfiable(416),
  expectationFailed(417),
  misreadRequest(421),

  // endregion

  // region 500
  internalServerError(500),
  notImplemented(501),
  badGateway(502),
  serviceUnavailable(503),
  gatewayTimeout(504),
  httpVersionNotSupported(505),
  variantAlsoNegotiates(506),
  insufficientStorage(507),
  loopDetected(508),
  bandwidthLimitExceeded(509),
  notExtended(510),
  networkAuthenticationRequired(511)
  ;
  // endregion

  final int code;

  const EHttpStatus(this.code);
}
