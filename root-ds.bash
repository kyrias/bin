#!/usr/bin/env bash
#
# Generate the DS records for the currently active root zone KSKs based on the IANA root-anchoors.xml file.
#
# Dependencies:
#  - curl
#  - yq (xq)
#  - jq
#
# The parseDate function was stolen from the jq issue tracker[0] because jq
# cannot parse ISO 8601 timestamps that have timezone offsets rather than 'Z'.
#
# [0]: https://github.com/stedolan/jq/issues/1053#issuecomment-580100213

curl -s https://data.iana.org/root-anchors/root-anchors.xml | \
	xq '
		def parseDate(date):
			date |
				capture("(?<no_tz>.*)(?<tz_sgn>[-+])(?<tz_hr>\\d{2}):(?<tz_min>\\d{2})$") |
				(.no_tz + "Z" | fromdateiso8601) - (.tz_sgn + "60" | tonumber) * ((.tz_hr | tonumber) * 60 + (.tz_min | tonumber));
		.TrustAnchor.KeyDigest |
			map(select(parseDate(."@validFrom") < now and (."@validUntil" == null or parseDate(."@validUntil") > now)))[] |
			".\tIN\tDS\t" + .KeyTag + " " + .Algorithm + " " + .DigestType + " " + .Digest' -r
