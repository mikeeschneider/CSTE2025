<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cda="urn:hl7-org:v3" xmlns:sdtc="urn:hl7-org:sdtc">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:variable name="FirstVersionCheck">
			<xsl:text>RCTC Version 2024-06-28 or 1.2.4.0</xsl:text>
		</xsl:variable>
		<xsl:variable name="FirstVersionXML">
			<xsl:text>RCTCexport2024-06-28.xml</xsl:text>
		</xsl:variable>
		<xsl:variable name="SecondVersionCheck">
			<xsl:text>RCTC Version 2024-04-05 or 1.2.3.0</xsl:text>
		</xsl:variable>
		<xsl:variable name="SecondVersionXML">
			<xsl:text>RCTCexport2024-04-05.xml</xsl:text>
		</xsl:variable>
		<xsl:variable name="ecrRoot" select="/cda:ClinicalDocument/cda:id/@root"/>
		<xsl:variable name="ecrExtension" select="/cda:ClinicalDocument/cda:id/@extension"/>
		<xsl:variable name="setId" select="/cda:ClinicalDocument/cda:setId/@extension"/>
		<xsl:variable name="version" select="/cda:ClinicalDocument/cda:versionNumber/@value"/>
		<xsl:variable name="ecrm" select="substring(/cda:ClinicalDocument/cda:effectiveTime/@value, 5, 2)"/>
		<xsl:variable name="ecrd" select="substring(/cda:ClinicalDocument/cda:effectiveTime/@value, 7, 2)"/>
		<xsl:variable name="ecry" select="substring(/cda:ClinicalDocument/cda:effectiveTime/@value, 0, 5)"/>
		<xsl:variable name="custodian" select="//cda:custodian/cda:assignedCustodian/cda:representedCustodianOrganization/cda:name"/>
		<xsl:variable name="facility" select="//cda:encompassingEncounter/cda:location/cda:healthCareFacility/cda:location/cda:name"/>
		<data>
			<!--RCTC Version 2024-06-28 or 1.2.4.0-->
			<xsl:choose>
				<xsl:when test="//cda:*[@sdtc:valueSetVersion='2024-06-28' or @sdtc:valueSetVersion='1.2.4.0']">
					<!--LABORATORY OBSERVATION CODES-->
					<xsl:choose>
						<xsl:when test="//cda:entry/cda:organizer[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.1']/cda:component/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.2']">
							<xsl:for-each select="//cda:entry/cda:organizer[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.1']/cda:component/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.2']">
								<xsl:variable name="code" select="cda:code/@code"/>
								<xsl:variable name="codeNull" select="cda:code/@nullFlavor"/>
								<xsl:variable name="value" select="cda:value/@code"/>
								<xsl:variable name="valueNull" select="cda:value/@nullFlavor"/>
								<record>
									<rctcVersion>
										<xsl:value-of select="$FirstVersionCheck"/>
									</rctcVersion>
									<scan>
										<xsl:text>Result Observation Codes</xsl:text>
									</scan>
									<ecrnumber>
										<xsl:value-of select="$ecrRoot"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="$ecrExtension"/>
									</ecrnumber>
									<setId>
										<xsl:value-of select="$setId"/>
									</setId>
									<version>
										<xsl:value-of select="$version"/>
										<xsl:text>^</xsl:text>
									</version>
									<ecrDate>
										<xsl:value-of select="$ecrm"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecrd"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecry"/>
									</ecrDate>
									<custodian>
										<xsl:value-of select="$custodian"/>
										<xsl:text>^</xsl:text>
									</custodian>
									<facility>
										<xsl:value-of select="$facility"/>
										<xsl:text>^</xsl:text>
									</facility>
									<code>
										<xsl:value-of select="$code"/>
										<xsl:value-of select="$codeNull"/>
										<xsl:text>^</xsl:text>
									</code>
									<originalText>
										<xsl:value-of select="normalize-space(cda:code/cda:originalText)"/>
										<xsl:text>^</xsl:text>
									</originalText>
									<value>
										<xsl:value-of select="$value"/>
										<xsl:value-of select="$valueNull"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:value/@displayName"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:interpretationCode/@code"/>
									</value>
									<triggered>
										<xsl:if test="cda:code[@code = $code]/@sdtc:valueSet">
											<xsl:text>Triggered in eCR</xsl:text>
										</xsl:if>
										<xsl:text>^</xsl:text>
									</triggered>
									<triggerMatch>
										<xsl:choose>
											<xsl:when test="document($FirstVersionXML)/all/LabObs/codes/code[@status = 'Active']/@code = $code">
												<xsl:text>Lab Obs Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/LabObs/codes/code[@status = 'Active'][@code = $code]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/LabObs/codes/code[@status = 'Active'][@code = $code]/@descriptor"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>No Trigger Match</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</triggerMatch>
								</record>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<record>
								<rctcVersion>
									<xsl:value-of select="$FirstVersionCheck"/>
								</rctcVersion>
								<scan>
									<xsl:text>No Result Observations</xsl:text>
								</scan>
								<ecrnumber>
									<xsl:value-of select="$ecrRoot"/>
									<xsl:text>^</xsl:text>
									<xsl:value-of select="$ecrExtension"/>
								</ecrnumber>
								<setId>
									<xsl:value-of select="$setId"/>
								</setId>
								<version>
									<xsl:value-of select="$version"/>
									<xsl:text>^</xsl:text>
								</version>
								<ecrDate>
									<xsl:value-of select="$ecrm"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecrd"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecry"/>
								</ecrDate>
								<custodian>
									<xsl:value-of select="$custodian"/>
									<xsl:text>^</xsl:text>
								</custodian>
								<facility>
									<xsl:value-of select="$facility"/>
									<xsl:text>^</xsl:text>
								</facility>
								<code>
									<xsl:text>No Result Observations</xsl:text>
								</code>
								<originalText>
									<xsl:text>No Result Observations</xsl:text>
								</originalText>
								<value>
									<xsl:text>No Result Observations</xsl:text>
								</value>
								<triggered>
									<xsl:text>No Result Observations</xsl:text>
								</triggered>
								<triggerMatch>
									<xsl:text>No Result Observations</xsl:text>
								</triggerMatch>
							</record>
						</xsl:otherwise>
					</xsl:choose>
					<!--PROBLEM ACT PROBLEM OBSERVATION VALUES-->
					<xsl:choose>
						<xsl:when test="//cda:act[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.3']/cda:entryRelationship/cda:observation[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.4']">
							<xsl:for-each select="//cda:act[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.3']/cda:entryRelationship/cda:observation[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.4']">
								<xsl:variable name="code" select="cda:code/@code"/>
								<xsl:variable name="codeNull" select="cda:code/@nullFlavor"/>
								<xsl:variable name="value" select="cda:value/@code"/>
								<xsl:variable name="valueNull" select="cda:value/@nullFlavor"/>
								<record>
									<rctcVersion>
										<xsl:value-of select="$FirstVersionCheck"/>
									</rctcVersion>
									<scan>
										<xsl:text>Problem Act Problem Observation Values</xsl:text>
									</scan>
									<ecrnumber>
										<xsl:value-of select="$ecrRoot"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="$ecrExtension"/>
									</ecrnumber>
									<setId>
										<xsl:value-of select="$setId"/>
									</setId>
									<version>
										<xsl:value-of select="$version"/>
										<xsl:text>^</xsl:text>
									</version>
									<ecrDate>
										<xsl:value-of select="$ecrm"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecrd"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecry"/>
									</ecrDate>
									<custodian>
										<xsl:value-of select="$custodian"/>
										<xsl:text>^</xsl:text>
									</custodian>
									<facility>
										<xsl:value-of select="$facility"/>
										<xsl:text>^</xsl:text>
									</facility>
									<code>
										<!--<xsl:value-of select="$code"/>
						<xsl:value-of select="$codeNull"/>-->
										<xsl:text>^</xsl:text>
									</code>
									<originalText>
										<xsl:value-of select="normalize-space(cda:code/cda:originalText)"/>
										<xsl:text>^</xsl:text>
									</originalText>
									<value>
										<xsl:value-of select="$value"/>
										<xsl:value-of select="$valueNull"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:value/@displayName"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:interpretationCode/@code"/>
									</value>
									<triggered>
										<xsl:if test="cda:value[@code = $value]/@sdtc:valueSet">
											<xsl:text>Triggered in eCR</xsl:text>
										</xsl:if>
										<xsl:text>^</xsl:text>
									</triggered>
									<triggerMatch>
										<xsl:choose>
											<xsl:when test="document($FirstVersionXML)/all/Diagnosis/codes/code[@status = 'Active']/@code = $value">
												<xsl:text>Diagnosis Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/Diagnosis/codes/code[@status = 'Active'][@code = $value]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/Diagnosis/codes/code[@status = 'Active'][@code = $value]/@descriptor"/>
											</xsl:when>
											<xsl:when test="document($FirstVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active']/@code = $value">
												<xsl:text>Suspect Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active'][@code = $value]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active'][@code = $value]/@descriptor"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>No Trigger Match</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</triggerMatch>
								</record>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<record>
								<rctcVersion>
									<xsl:value-of select="$FirstVersionCheck"/>
								</rctcVersion>
								<scan>
									<xsl:text>No Problem Act Problem Observation Values</xsl:text>
								</scan>
								<ecrnumber>
									<xsl:value-of select="$ecrRoot"/>
									<xsl:text>^</xsl:text>
									<xsl:value-of select="$ecrExtension"/>
								</ecrnumber>
								<setId>
									<xsl:value-of select="$setId"/>
								</setId>
								<version>
									<xsl:value-of select="$version"/>
									<xsl:text>^</xsl:text>
								</version>
								<ecrDate>
									<xsl:value-of select="$ecrm"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecrd"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecry"/>
								</ecrDate>
								<custodian>
									<xsl:value-of select="$custodian"/>
									<xsl:text>^</xsl:text>
								</custodian>
								<facility>
									<xsl:value-of select="$facility"/>
									<xsl:text>^</xsl:text>
								</facility>
								<code>
									<xsl:text>No Problem Act Problem Observation Values</xsl:text>
								</code>
								<originalText>
									<xsl:text>No Problem Act Problem Observation Values</xsl:text>
								</originalText>
								<value>
									<xsl:text>No Problem Act Problem Observation Values</xsl:text>
								</value>
								<triggered>
									<xsl:text>No Problem Act Problem Observation Values</xsl:text>
								</triggered>
								<triggerMatch>
									<xsl:text>No Problem Act Problem Observation Values</xsl:text>
								</triggerMatch>
							</record>
						</xsl:otherwise>
					</xsl:choose>
					<!--PROBLEM ACT PROBLEM OBSERVATIONS ICD10 TRANSLATION-->
					<xsl:choose>
						<xsl:when test="//cda:act[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.3']/cda:entryRelationship/cda:observation[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.4']">
							<xsl:for-each select="//cda:act[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.3']/cda:entryRelationship/cda:observation[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.4']">
								<xsl:variable name="code" select="cda:code/@code"/>
								<xsl:variable name="codeNull" select="cda:code/@nullFlavor"/>
								<xsl:variable name="value" select="cda:value/cda:translation[@codeSystem = '2.16.840.1.113883.6.90']/@code"/>
								<xsl:variable name="valueNull" select="cda:value/cda:translation[@codeSystem = '2.16.840.1.113883.6.90']/@nullFlavor"/>
								<record>
									<rctcVersion>
										<xsl:value-of select="$FirstVersionCheck"/>
									</rctcVersion>
									<scan>
										<xsl:text>Problem Act Problem Observation ICD10 Translation</xsl:text>
									</scan>
									<ecrnumber>
										<xsl:value-of select="$ecrRoot"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="$ecrExtension"/>
									</ecrnumber>
									<setId>
										<xsl:value-of select="$setId"/>
									</setId>
									<version>
										<xsl:value-of select="$version"/>
										<xsl:text>^</xsl:text>
									</version>
									<ecrDate>
										<xsl:value-of select="$ecrm"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecrd"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecry"/>
									</ecrDate>
									<custodian>
										<xsl:value-of select="$custodian"/>
										<xsl:text>^</xsl:text>
									</custodian>
									<facility>
										<xsl:value-of select="$facility"/>
										<xsl:text>^</xsl:text>
									</facility>
									<code>
										<!--<xsl:value-of select="$code"/>
						<xsl:value-of select="$codeNull"/>-->
										<xsl:text>^</xsl:text>
									</code>
									<originalText>
										<xsl:value-of select="normalize-space(cda:code/cda:originalText)"/>
										<xsl:text>^</xsl:text>
									</originalText>
									<value>
										<xsl:value-of select="$value"/>
										<xsl:value-of select="$valueNull"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:value/@displayName"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:interpretationCode/@code"/>
									</value>
									<triggered>
										<xsl:if test="cda:value/cda:translation[@codeSystem = '2.16.840.1.113883.6.90'][@code = $value]/@sdtc:valueSet">
											<xsl:text>Triggered in eCR</xsl:text>
										</xsl:if>
										<xsl:text>^</xsl:text>
									</triggered>
									<triggerMatch>
										<xsl:choose>
											<xsl:when test="document($FirstVersionXML)/all/Diagnosis/codes/code[@status = 'Active']/@code = $value">
												<xsl:text>Diagnosis Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/Diagnosis/codes/code[@status = 'Active'][@code = $value]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/Diagnosis/codes/code[@status = 'Active'][@code = $value]/@descriptor"/>
											</xsl:when>
											<xsl:when test="document($FirstVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active']/@code = $value">
												<xsl:text>Suspect Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active'][@code = $value]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active'][@code = $value]/@descriptor"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>No Trigger Match</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</triggerMatch>
								</record>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<record>
								<rctcVersion>
									<xsl:value-of select="$FirstVersionCheck"/>
								</rctcVersion>
								<scan>
									<xsl:text>No Problem Act Problem Observation ICD10 Translation</xsl:text>
								</scan>
								<ecrnumber>
									<xsl:value-of select="$ecrRoot"/>
									<xsl:text>^</xsl:text>
									<xsl:value-of select="$ecrExtension"/>
								</ecrnumber>
								<setId>
									<xsl:value-of select="$setId"/>
								</setId>
								<version>
									<xsl:value-of select="$version"/>
									<xsl:text>^</xsl:text>
								</version>
								<ecrDate>
									<xsl:value-of select="$ecrm"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecrd"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecry"/>
								</ecrDate>
								<custodian>
									<xsl:value-of select="$custodian"/>
									<xsl:text>^</xsl:text>
								</custodian>
								<facility>
									<xsl:value-of select="$facility"/>
									<xsl:text>^</xsl:text>
								</facility>
								<code>
									<xsl:text>No Problem Act Problem Observation ICD10 Translation</xsl:text>
								</code>
								<originalText>
									<xsl:text>No Problem Act Problem Observation ICD10 Translation</xsl:text>
								</originalText>
								<value>
									<xsl:text>No Problem Act Problem Observation ICD10 Translation</xsl:text>
								</value>
								<triggered>
									<xsl:text>No Problem Act Problem Observation ICD10 Translation</xsl:text>
								</triggered>
								<triggerMatch>
									<xsl:text>No Problem Act Problem Observation ICD10 Translation</xsl:text>
								</triggerMatch>
							</record>
						</xsl:otherwise>
					</xsl:choose>
					<!--ENCOUNTER DIAGNOSIS PROBLEM OBSERVATION VALUES-->
					<xsl:choose>
						<xsl:when test="//cda:act[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.80']/cda:entryRelationship/cda:observation[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.4']">
							<xsl:for-each select="//cda:act[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.80']/cda:entryRelationship/cda:observation[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.4']">
								<xsl:variable name="code" select="cda:code/@code"/>
								<xsl:variable name="codeNull" select="cda:code/@nullFlavor"/>
								<xsl:variable name="value" select="cda:value/@code"/>
								<xsl:variable name="valueNull" select="cda:value/@nullFlavor"/>
								<record>
									<rctcVersion>
										<xsl:value-of select="$FirstVersionCheck"/>
									</rctcVersion>
									<scan>
										<xsl:text>Encounter Diagnosis Problem Observation Values</xsl:text>
									</scan>
									<ecrnumber>
										<xsl:value-of select="$ecrRoot"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="$ecrExtension"/>
									</ecrnumber>
									<setId>
										<xsl:value-of select="$setId"/>
									</setId>
									<version>
										<xsl:value-of select="$version"/>
										<xsl:text>^</xsl:text>
									</version>
									<ecrDate>
										<xsl:value-of select="$ecrm"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecrd"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecry"/>
									</ecrDate>
									<custodian>
										<xsl:value-of select="$custodian"/>
										<xsl:text>^</xsl:text>
									</custodian>
									<facility>
										<xsl:value-of select="$facility"/>
										<xsl:text>^</xsl:text>
									</facility>
									<code>
										<!--<xsl:value-of select="$code"/>
						<xsl:value-of select="$codeNull"/>-->
										<xsl:text>^</xsl:text>
									</code>
									<originalText>
										<xsl:value-of select="normalize-space(cda:code/cda:originalText)"/>
										<xsl:text>^</xsl:text>
									</originalText>
									<value>
										<xsl:value-of select="$value"/>
										<xsl:value-of select="$valueNull"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:value/@displayName"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:interpretationCode/@code"/>
									</value>
									<triggered>
										<xsl:if test="cda:value[@code = $value]/@sdtc:valueSet">
											<xsl:text>Triggered in eCR</xsl:text>
										</xsl:if>
										<xsl:text>^</xsl:text>
									</triggered>
									<triggerMatch>
										<xsl:choose>
											<xsl:when test="document($FirstVersionXML)/all/Diagnosis/codes/code[@status = 'Active']/@code = $value">
												<xsl:text>Diagnosis Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/Diagnosis/codes/code[@status = 'Active'][@code = $value]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/Diagnosis/codes/code[@status = 'Active'][@code = $value]/@descriptor"/>
											</xsl:when>
											<xsl:when test="document($FirstVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active']/@code = $value">
												<xsl:text>Suspect Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active'][@code = $value]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active'][@code = $value]/@descriptor"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>No Trigger Match</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</triggerMatch>
								</record>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<record>
								<rctcVersion>
									<xsl:value-of select="$FirstVersionCheck"/>
								</rctcVersion>
								<scan>
									<xsl:text>No Encounter Diagnosis Problem Observation Values</xsl:text>
								</scan>
								<ecrnumber>
									<xsl:value-of select="$ecrRoot"/>
									<xsl:text>^</xsl:text>
									<xsl:value-of select="$ecrExtension"/>
								</ecrnumber>
								<setId>
									<xsl:value-of select="$setId"/>
								</setId>
								<version>
									<xsl:value-of select="$version"/>
									<xsl:text>^</xsl:text>
								</version>
								<ecrDate>
									<xsl:value-of select="$ecrm"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecrd"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecry"/>
								</ecrDate>
								<custodian>
									<xsl:value-of select="$custodian"/>
									<xsl:text>^</xsl:text>
								</custodian>
								<facility>
									<xsl:value-of select="$facility"/>
									<xsl:text>^</xsl:text>
								</facility>
								<code>
									<xsl:text>No Encounter Diagnosis Problem Observation Values</xsl:text>
								</code>
								<originalText>
									<xsl:text>No Encounter Diagnosis Problem Observation Values</xsl:text>
								</originalText>
								<value>
									<xsl:text>No Encounter Diagnosis Problem Observation Values</xsl:text>
								</value>
								<triggered>
									<xsl:text>No Encounter Diagnosis Problem Observation Values</xsl:text>
								</triggered>
								<triggerMatch>
									<xsl:text>No Encounter Diagnosis Problem Observation Values</xsl:text>
								</triggerMatch>
							</record>
						</xsl:otherwise>
					</xsl:choose>
					<!--CHIEF COMPLAINT VALUE-->
					<xsl:choose>
						<xsl:when test="//cda:observation[cda:code/@code = '8661-1']">
							<xsl:for-each select="//cda:observation[cda:code/@code = '8661-1']">
								<xsl:variable name="code" select="cda:code/@code"/>
								<xsl:variable name="codeNull" select="cda:code/@nullFlavor"/>
								<xsl:variable name="value" select="cda:value/@code"/>
								<xsl:variable name="valueNull" select="cda:value/@nullFlavor"/>
								<record>
									<rctcVersion>
										<xsl:value-of select="$FirstVersionCheck"/>
									</rctcVersion>
									<scan>
										<xsl:text>Chief Complaint Value</xsl:text>
									</scan>
									<ecrnumber>
										<xsl:value-of select="$ecrRoot"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="$ecrExtension"/>
									</ecrnumber>
									<setId>
										<xsl:value-of select="$setId"/>
									</setId>
									<version>
										<xsl:value-of select="$version"/>
										<xsl:text>^</xsl:text>
									</version>
									<ecrDate>
										<xsl:value-of select="$ecrm"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecrd"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecry"/>
									</ecrDate>
									<custodian>
										<xsl:value-of select="$custodian"/>
										<xsl:text>^</xsl:text>
									</custodian>
									<facility>
										<xsl:value-of select="$facility"/>
										<xsl:text>^</xsl:text>
									</facility>
									<code>
										<!--<xsl:value-of select="$code"/>
						<xsl:value-of select="$codeNull"/>-->
										<xsl:text>^</xsl:text>
									</code>
									<originalText>
										<xsl:value-of select="normalize-space(cda:code/cda:originalText)"/>
										<xsl:text>^</xsl:text>
									</originalText>
									<value>
										<xsl:value-of select="$value"/>
										<xsl:value-of select="$valueNull"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:value/@displayName"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:interpretationCode/@code"/>
									</value>
									<triggered>
										<xsl:if test="cda:value[@code = $value]/@sdtc:valueSet">
											<xsl:text>Triggered in eCR</xsl:text>
										</xsl:if>
										<xsl:text>^</xsl:text>
									</triggered>
									<triggerMatch>
										<xsl:choose>
											<xsl:when test="document($FirstVersionXML)/all/Diagnosis/codes/code[@status = 'Active']/@code = $value">
												<xsl:text>Diagnosis Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/Diagnosis/codes/code[@status = 'Active'][@code = $value]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/Diagnosis/codes/code[@status = 'Active'][@code = $value]/@descriptor"/>
											</xsl:when>
											<xsl:when test="document($FirstVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active']/@code = $value">
												<xsl:text>Suspect Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active'][@code = $value]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active'][@code = $value]/@descriptor"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>No Trigger Match</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</triggerMatch>
								</record>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<record>
								<rctcVersion>
									<xsl:value-of select="$FirstVersionCheck"/>
								</rctcVersion>
								<scan>
									<xsl:text>No Chief Complaint Value</xsl:text>
								</scan>
								<ecrnumber>
									<xsl:value-of select="$ecrRoot"/>
									<xsl:text>^</xsl:text>
									<xsl:value-of select="$ecrExtension"/>
								</ecrnumber>
								<setId>
									<xsl:value-of select="$setId"/>
								</setId>
								<version>
									<xsl:value-of select="$version"/>
									<xsl:text>^</xsl:text>
								</version>
								<ecrDate>
									<xsl:value-of select="$ecrm"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecrd"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecry"/>
								</ecrDate>
								<custodian>
									<xsl:value-of select="$custodian"/>
									<xsl:text>^</xsl:text>
								</custodian>
								<facility>
									<xsl:value-of select="$facility"/>
									<xsl:text>^</xsl:text>
								</facility>
								<code>
									<xsl:text>No Chief Complaint Value</xsl:text>
								</code>
								<originalText>
									<xsl:text>No Chief Complaint Value</xsl:text>
								</originalText>
								<value>
									<xsl:text>No Chief Complaint Value</xsl:text>
								</value>
								<triggered>
									<xsl:text>No Chief Complaint Value</xsl:text>
								</triggered>
								<triggerMatch>
									<xsl:text>No Chief Complaint Value</xsl:text>
								</triggerMatch>
							</record>
						</xsl:otherwise>
					</xsl:choose>
					<!--ORGANISM VALUE-->
					<xsl:choose>
						<xsl:when test="//cda:entry/cda:organizer[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.1']/cda:component/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.2']">
							<xsl:for-each select="//cda:entry/cda:organizer[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.1']/cda:component/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.2']">
								<xsl:variable name="code" select="cda:code/@code"/>
								<xsl:variable name="codeNull" select="cda:code/@nullFlavor"/>
								<xsl:variable name="value" select="cda:value/@code"/>
								<xsl:variable name="valueNull" select="cda:value/@nullFlavor"/>
								<record>
									<rctcVersion>
										<xsl:value-of select="$FirstVersionCheck"/>
									</rctcVersion>
									<scan>
										<xsl:text>Result Observation Organism Value</xsl:text>
									</scan>
									<ecrnumber>
										<xsl:value-of select="$ecrRoot"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="$ecrExtension"/>
									</ecrnumber>
									<setId>
										<xsl:value-of select="$setId"/>
									</setId>
									<version>
										<xsl:value-of select="$version"/>
										<xsl:text>^</xsl:text>
									</version>
									<ecrDate>
										<xsl:value-of select="$ecrm"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecrd"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecry"/>
									</ecrDate>
									<custodian>
										<xsl:value-of select="$custodian"/>
										<xsl:text>^</xsl:text>
									</custodian>
									<facility>
										<xsl:value-of select="$facility"/>
										<xsl:text>^</xsl:text>
									</facility>
									<code>
										<xsl:value-of select="$code"/>
										<xsl:value-of select="$codeNull"/>
										<xsl:text>^</xsl:text>
									</code>
									<originalText>
										<xsl:value-of select="normalize-space(cda:code/cda:originalText)"/>
										<xsl:text>^</xsl:text>
									</originalText>
									<value>
										<xsl:value-of select="$value"/>
										<xsl:value-of select="$valueNull"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:value/@displayName"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:interpretationCode/@code"/>
									</value>
									<triggered>
										<xsl:if test="cda:value[@code = $value]/@sdtc:valueSet">
											<xsl:text>Triggered in eCR</xsl:text>
										</xsl:if>
										<xsl:text>^</xsl:text>
									</triggered>
									<triggerMatch>
										<xsl:choose>
											<xsl:when test="document($FirstVersionXML)/all/Organism/codes/code[@status = 'Active']/@code = $value">
												<xsl:text>Organism Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/Organism/codes/code[@status = 'Active'][@code = $value]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/Organism/codes/code[@status = 'Active'][@code = $value]/@descriptor"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>No Trigger Match</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</triggerMatch>
								</record>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<record>
								<rctcVersion>
									<xsl:value-of select="$FirstVersionCheck"/>
								</rctcVersion>
								<scan>
									<xsl:text>Result Observation Organism Value</xsl:text>
								</scan>
								<ecrnumber>
									<xsl:value-of select="$ecrRoot"/>
									<xsl:text>^</xsl:text>
									<xsl:value-of select="$ecrExtension"/>
								</ecrnumber>
								<setId>
									<xsl:value-of select="$setId"/>
								</setId>
								<version>
									<xsl:value-of select="$version"/>
									<xsl:text>^</xsl:text>
								</version>
								<ecrDate>
									<xsl:value-of select="$ecrm"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecrd"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecry"/>
								</ecrDate>
								<custodian>
									<xsl:value-of select="$custodian"/>
									<xsl:text>^</xsl:text>
								</custodian>
								<facility>
									<xsl:value-of select="$facility"/>
									<xsl:text>^</xsl:text>
								</facility>
								<code>
									<xsl:text>No Result Observations</xsl:text>
								</code>
								<originalText>
									<xsl:text>No Result Observations</xsl:text>
								</originalText>
								<value>
									<xsl:text>No Result Observations</xsl:text>
								</value>
								<triggered>
									<xsl:text>No Result Observations</xsl:text>
								</triggered>
								<triggerMatch>
									<xsl:text>No Result Observations</xsl:text>
								</triggerMatch>
							</record>
						</xsl:otherwise>
					</xsl:choose>
					<!--PLANNED OBSERVATION CODE-->
					<xsl:choose>
						<xsl:when test="//cda:observation[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.44']">
							<xsl:for-each select="//cda:observation[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.44']">
								<xsl:variable name="code" select="cda:code/@code"/>
								<xsl:variable name="codeNull" select="cda:code/@nullFlavor"/>
								<xsl:variable name="value" select="cda:value/@code"/>
								<xsl:variable name="valueNull" select="cda:value/@nullFlavor"/>
								<record>
									<rctcVersion>
										<xsl:value-of select="$FirstVersionCheck"/>
									</rctcVersion>
									<scan>
										<xsl:text>Planned Observation Codes</xsl:text>
									</scan>
									<ecrnumber>
										<xsl:value-of select="$ecrRoot"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="$ecrExtension"/>
									</ecrnumber>
									<setId>
										<xsl:value-of select="$setId"/>
									</setId>
									<version>
										<xsl:value-of select="$version"/>
										<xsl:text>^</xsl:text>
									</version>
									<ecrDate>
										<xsl:value-of select="$ecrm"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecrd"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecry"/>
									</ecrDate>
									<custodian>
										<xsl:value-of select="$custodian"/>
										<xsl:text>^</xsl:text>
									</custodian>
									<facility>
										<xsl:value-of select="$facility"/>
										<xsl:text>^</xsl:text>
									</facility>
									<code>
										<xsl:value-of select="$code"/>
										<xsl:value-of select="$codeNull"/>
										<xsl:text>^</xsl:text>
									</code>
									<originalText>
										<xsl:value-of select="normalize-space(cda:code/cda:originalText)"/>
										<xsl:text>^</xsl:text>
									</originalText>
									<value>
										<xsl:value-of select="$value"/>
										<xsl:value-of select="$valueNull"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:value/@displayName"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:interpretationCode/@code"/>
									</value>
									<triggered>
										<xsl:if test="cda:code[@code = $code]/@sdtc:valueSet">
											<xsl:text>Triggered in eCR</xsl:text>
										</xsl:if>
										<xsl:text>^</xsl:text>
									</triggered>
									<triggerMatch>
										<xsl:choose>
											<xsl:when test="document($FirstVersionXML)/all/LabOrder/codes/code[@status = 'Active']/@code = $code">
												<xsl:text>Planned Obs Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/LabOrder/codes/code[@status = 'Active'][@code = $code]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/LabOrder/codes/code[@status = 'Active'][@code = $code]/@descriptor"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>No Trigger Match</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</triggerMatch>
								</record>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<record>
								<rctcVersion>
									<xsl:value-of select="$FirstVersionCheck"/>
								</rctcVersion>
								<scan>
									<xsl:text>No Planned Observations</xsl:text>
								</scan>
								<ecrnumber>
									<xsl:value-of select="$ecrRoot"/>
									<xsl:text>^</xsl:text>
									<xsl:value-of select="$ecrExtension"/>
								</ecrnumber>
								<setId>
									<xsl:value-of select="$setId"/>
								</setId>
								<version>
									<xsl:value-of select="$version"/>
									<xsl:text>^</xsl:text>
								</version>
								<ecrDate>
									<xsl:value-of select="$ecrm"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecrd"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecry"/>
								</ecrDate>
								<custodian>
									<xsl:value-of select="$custodian"/>
									<xsl:text>^</xsl:text>
								</custodian>
								<facility>
									<xsl:value-of select="$facility"/>
									<xsl:text>^</xsl:text>
								</facility>
								<code>
									<xsl:text>No Planned Observations</xsl:text>
								</code>
								<originalText>
									<xsl:text>No Planned Observations</xsl:text>
								</originalText>
								<value>
									<xsl:text>No Planned Observations</xsl:text>
								</value>
								<triggered>
									<xsl:text>No Planned Observations</xsl:text>
								</triggered>
								<triggerMatch>
									<xsl:text>No Planned Observations</xsl:text>
								</triggerMatch>
							</record>
						</xsl:otherwise>
					</xsl:choose>
					<!--MEDICATION CODES-->
					<xsl:choose>
						<xsl:when test="//cda:substanceAdministration[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.16']">
							<xsl:for-each select="//cda:substanceAdministration[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.16']">
								<xsl:variable name="code" select="cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code/@code"/>
								<xsl:variable name="codeNull" select="cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code/@nullFlavor"/>
								<xsl:variable name="value" select="cda:value/@code"/>
								<xsl:variable name="valueNull" select="cda:value/@nullFlavor"/>
								<record>
									<rctcVersion>
										<xsl:value-of select="$FirstVersionCheck"/>
									</rctcVersion>
									<scan>
										<xsl:text>Medication Codes</xsl:text>
									</scan>
									<ecrnumber>
										<xsl:value-of select="$ecrRoot"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="$ecrExtension"/>
									</ecrnumber>
									<setId>
										<xsl:value-of select="$setId"/>
									</setId>
									<version>
										<xsl:value-of select="$version"/>
										<xsl:text>^</xsl:text>
									</version>
									<ecrDate>
										<xsl:value-of select="$ecrm"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecrd"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecry"/>
									</ecrDate>
									<custodian>
										<xsl:value-of select="$custodian"/>
										<xsl:text>^</xsl:text>
									</custodian>
									<facility>
										<xsl:value-of select="$facility"/>
										<xsl:text>^</xsl:text>
									</facility>
									<code>
										<xsl:value-of select="$code"/>
										<xsl:value-of select="$codeNull"/>
										<xsl:text>^</xsl:text>
									</code>
									<originalText>
										<xsl:value-of select="normalize-space(cda:code/cda:originalText)"/>
										<xsl:text>^</xsl:text>
									</originalText>
									<value>
										<xsl:value-of select="$value"/>
										<xsl:value-of select="$valueNull"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:value/@displayName"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:interpretationCode/@code"/>
									</value>
									<triggered>
										<xsl:if test="cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code[@code = $code]/@sdtc:valueSet">
											<xsl:text>Triggered in eCR</xsl:text>
										</xsl:if>
										<xsl:text>^</xsl:text>
									</triggered>
									<triggerMatch>
										<xsl:choose>
											<xsl:when test="document($FirstVersionXML)/all/Medication/codes/code[@status = 'Active']/@code = $code">
												<xsl:text>Medication Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/Medication/codes/code[@status = 'Active'][@code = $code]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($FirstVersionXML)/all/Medication/codes/code[@status = 'Active'][@code = $code]/@descriptor"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>No Trigger Match</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</triggerMatch>
								</record>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<record>
								<rctcVersion>
									<xsl:value-of select="$FirstVersionCheck"/>
								</rctcVersion>
								<scan>
									<xsl:text>No Medication Codes</xsl:text>
								</scan>
								<ecrnumber>
									<xsl:value-of select="$ecrRoot"/>
									<xsl:text>^</xsl:text>
									<xsl:value-of select="$ecrExtension"/>
								</ecrnumber>
								<setId>
									<xsl:value-of select="$setId"/>
								</setId>
								<version>
									<xsl:value-of select="$version"/>
									<xsl:text>^</xsl:text>
								</version>
								<ecrDate>
									<xsl:value-of select="$ecrm"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecrd"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecry"/>
								</ecrDate>
								<custodian>
									<xsl:value-of select="$custodian"/>
									<xsl:text>^</xsl:text>
								</custodian>
								<facility>
									<xsl:value-of select="$facility"/>
									<xsl:text>^</xsl:text>
								</facility>
								<code>
									<xsl:text>No Medication Codes</xsl:text>
								</code>
								<originalText>
									<xsl:text>No Medication Codes</xsl:text>
								</originalText>
								<value>
									<xsl:text>No Medication Codes</xsl:text>
								</value>
								<triggered>
									<xsl:text>No Medication Codes</xsl:text>
								</triggered>
								<triggerMatch>
									<xsl:text>No Medication Codes</xsl:text>
								</triggerMatch>
							</record>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<!--RCTC Version 2024-04-05 or 1.2.3.0 (Second Version Check)-->
				<xsl:when test="//cda:*[@sdtc:valueSetVersion='2024-04-05' or @sdtc:valueSetVersion='1.2.3.0']">
					<!--LABORATORY OBSERVATION CODES-->
					<xsl:choose>
						<xsl:when test="//cda:entry/cda:organizer[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.1']/cda:component/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.2']">
							<xsl:for-each select="//cda:entry/cda:organizer[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.1']/cda:component/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.2']">
								<xsl:variable name="code" select="cda:code/@code"/>
								<xsl:variable name="codeNull" select="cda:code/@nullFlavor"/>
								<xsl:variable name="value" select="cda:value/@code"/>
								<xsl:variable name="valueNull" select="cda:value/@nullFlavor"/>
								<record>
									<rctcVersion>
										<xsl:value-of select="$SecondVersionCheck"/>
									</rctcVersion>
									<scan>
										<xsl:text>Result Observation Codes</xsl:text>
									</scan>
									<ecrnumber>
										<xsl:value-of select="$ecrRoot"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="$ecrExtension"/>
									</ecrnumber>
									<setId>
										<xsl:value-of select="$setId"/>
									</setId>
									<version>
										<xsl:value-of select="$version"/>
										<xsl:text>^</xsl:text>
									</version>
									<ecrDate>
										<xsl:value-of select="$ecrm"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecrd"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecry"/>
									</ecrDate>
									<custodian>
										<xsl:value-of select="$custodian"/>
										<xsl:text>^</xsl:text>
									</custodian>
									<facility>
										<xsl:value-of select="$facility"/>
										<xsl:text>^</xsl:text>
									</facility>
									<code>
										<xsl:value-of select="$code"/>
										<xsl:value-of select="$codeNull"/>
										<xsl:text>^</xsl:text>
									</code>
									<originalText>
										<xsl:value-of select="normalize-space(cda:code/cda:originalText)"/>
										<xsl:text>^</xsl:text>
									</originalText>
									<value>
										<xsl:value-of select="$value"/>
										<xsl:value-of select="$valueNull"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:value/@displayName"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:interpretationCode/@code"/>
									</value>
									<triggered>
										<xsl:if test="cda:code[@code = $code]/@sdtc:valueSet">
											<xsl:text>Triggered in eCR</xsl:text>
										</xsl:if>
										<xsl:text>^</xsl:text>
									</triggered>
									<triggerMatch>
										<xsl:choose>
											<xsl:when test="document($SecondVersionXML)/all/LabObs/codes/code[@status = 'Active']/@code = $code">
												<xsl:text>Lab Obs Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/LabObs/codes/code[@status = 'Active'][@code = $code]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/LabObs/codes/code[@status = 'Active'][@code = $code]/@descriptor"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>No Trigger Match</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</triggerMatch>
								</record>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<record>
								<rctcVersion>
									<xsl:value-of select="$SecondVersionCheck"/>
								</rctcVersion>
								<scan>
									<xsl:text>No Result Observations</xsl:text>
								</scan>
								<ecrnumber>
									<xsl:value-of select="$ecrRoot"/>
									<xsl:text>^</xsl:text>
									<xsl:value-of select="$ecrExtension"/>
								</ecrnumber>
								<setId>
									<xsl:value-of select="$setId"/>
								</setId>
								<version>
									<xsl:value-of select="$version"/>
									<xsl:text>^</xsl:text>
								</version>
								<ecrDate>
									<xsl:value-of select="$ecrm"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecrd"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecry"/>
								</ecrDate>
								<custodian>
									<xsl:value-of select="$custodian"/>
									<xsl:text>^</xsl:text>
								</custodian>
								<facility>
									<xsl:value-of select="$facility"/>
									<xsl:text>^</xsl:text>
								</facility>
								<code>
									<xsl:text>No Result Observations</xsl:text>
								</code>
								<originalText>
									<xsl:text>No Result Observations</xsl:text>
								</originalText>
								<value>
									<xsl:text>No Result Observations</xsl:text>
								</value>
								<triggered>
									<xsl:text>No Result Observations</xsl:text>
								</triggered>
								<triggerMatch>
									<xsl:text>No Result Observations</xsl:text>
								</triggerMatch>
							</record>
						</xsl:otherwise>
					</xsl:choose>
					<!--PROBLEM ACT PROBLEM OBSERVATION VALUES-->
					<xsl:choose>
						<xsl:when test="//cda:act[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.3']/cda:entryRelationship/cda:observation[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.4']">
							<xsl:for-each select="//cda:act[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.3']/cda:entryRelationship/cda:observation[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.4']">
								<xsl:variable name="code" select="cda:code/@code"/>
								<xsl:variable name="codeNull" select="cda:code/@nullFlavor"/>
								<xsl:variable name="value" select="cda:value/@code"/>
								<xsl:variable name="valueNull" select="cda:value/@nullFlavor"/>
								<record>
									<rctcVersion>
										<xsl:value-of select="$SecondVersionCheck"/>
									</rctcVersion>
									<scan>
										<xsl:text>Problem Act Problem Observation Values</xsl:text>
									</scan>
									<ecrnumber>
										<xsl:value-of select="$ecrRoot"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="$ecrExtension"/>
									</ecrnumber>
									<setId>
										<xsl:value-of select="$setId"/>
									</setId>
									<version>
										<xsl:value-of select="$version"/>
										<xsl:text>^</xsl:text>
									</version>
									<ecrDate>
										<xsl:value-of select="$ecrm"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecrd"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecry"/>
									</ecrDate>
									<custodian>
										<xsl:value-of select="$custodian"/>
										<xsl:text>^</xsl:text>
									</custodian>
									<facility>
										<xsl:value-of select="$facility"/>
										<xsl:text>^</xsl:text>
									</facility>
									<code>
										<!--<xsl:value-of select="$code"/>
						<xsl:value-of select="$codeNull"/>-->
										<xsl:text>^</xsl:text>
									</code>
									<originalText>
										<xsl:value-of select="normalize-space(cda:code/cda:originalText)"/>
										<xsl:text>^</xsl:text>
									</originalText>
									<value>
										<xsl:value-of select="$value"/>
										<xsl:value-of select="$valueNull"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:value/@displayName"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:interpretationCode/@code"/>
									</value>
									<triggered>
										<xsl:if test="cda:value[@code = $value]/@sdtc:valueSet">
											<xsl:text>Triggered in eCR</xsl:text>
										</xsl:if>
										<xsl:text>^</xsl:text>
									</triggered>
									<triggerMatch>
										<xsl:choose>
											<xsl:when test="document($SecondVersionXML)/all/Diagnosis/codes/code[@status = 'Active']/@code = $value">
												<xsl:text>Diagnosis Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/Diagnosis/codes/code[@status = 'Active'][@code = $value]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/Diagnosis/codes/code[@status = 'Active'][@code = $value]/@descriptor"/>
											</xsl:when>
											<xsl:when test="document($SecondVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active']/@code = $value">
												<xsl:text>Suspect Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active'][@code = $value]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active'][@code = $value]/@descriptor"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>No Trigger Match</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</triggerMatch>
								</record>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<record>
								<rctcVersion>
									<xsl:value-of select="$SecondVersionCheck"/>
								</rctcVersion>
								<scan>
									<xsl:text>No Problem Act Problem Observation Values</xsl:text>
								</scan>
								<ecrnumber>
									<xsl:value-of select="$ecrRoot"/>
									<xsl:text>^</xsl:text>
									<xsl:value-of select="$ecrExtension"/>
								</ecrnumber>
								<setId>
									<xsl:value-of select="$setId"/>
								</setId>
								<version>
									<xsl:value-of select="$version"/>
									<xsl:text>^</xsl:text>
								</version>
								<ecrDate>
									<xsl:value-of select="$ecrm"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecrd"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecry"/>
								</ecrDate>
								<custodian>
									<xsl:value-of select="$custodian"/>
									<xsl:text>^</xsl:text>
								</custodian>
								<facility>
									<xsl:value-of select="$facility"/>
									<xsl:text>^</xsl:text>
								</facility>
								<code>
									<xsl:text>No Problem Act Problem Observation Values</xsl:text>
								</code>
								<originalText>
									<xsl:text>No Problem Act Problem Observation Values</xsl:text>
								</originalText>
								<value>
									<xsl:text>No Problem Act Problem Observation Values</xsl:text>
								</value>
								<triggered>
									<xsl:text>No Problem Act Problem Observation Values</xsl:text>
								</triggered>
								<triggerMatch>
									<xsl:text>No Problem Act Problem Observation Values</xsl:text>
								</triggerMatch>
							</record>
						</xsl:otherwise>
					</xsl:choose>
					<!--PROBLEM ACT PROBLEM OBSERVATIONS ICD10 TRANSLATION-->
					<xsl:choose>
						<xsl:when test="//cda:act[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.3']/cda:entryRelationship/cda:observation[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.4']">
							<xsl:for-each select="//cda:act[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.3']/cda:entryRelationship/cda:observation[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.4']">
								<xsl:variable name="code" select="cda:code/@code"/>
								<xsl:variable name="codeNull" select="cda:code/@nullFlavor"/>
								<xsl:variable name="value" select="cda:value/cda:translation[@codeSystem = '2.16.840.1.113883.6.90']/@code"/>
								<xsl:variable name="valueNull" select="cda:value/cda:translation[@codeSystem = '2.16.840.1.113883.6.90']/@nullFlavor"/>
								<record>
									<rctcVersion>
										<xsl:value-of select="$SecondVersionCheck"/>
									</rctcVersion>
									<scan>
										<xsl:text>Problem Act Problem Observation ICD10 Translation</xsl:text>
									</scan>
									<ecrnumber>
										<xsl:value-of select="$ecrRoot"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="$ecrExtension"/>
									</ecrnumber>
									<setId>
										<xsl:value-of select="$setId"/>
									</setId>
									<version>
										<xsl:value-of select="$version"/>
										<xsl:text>^</xsl:text>
									</version>
									<ecrDate>
										<xsl:value-of select="$ecrm"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecrd"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecry"/>
									</ecrDate>
									<custodian>
										<xsl:value-of select="$custodian"/>
										<xsl:text>^</xsl:text>
									</custodian>
									<facility>
										<xsl:value-of select="$facility"/>
										<xsl:text>^</xsl:text>
									</facility>
									<code>
										<!--<xsl:value-of select="$code"/>
						<xsl:value-of select="$codeNull"/>-->
										<xsl:text>^</xsl:text>
									</code>
									<originalText>
										<xsl:value-of select="normalize-space(cda:code/cda:originalText)"/>
										<xsl:text>^</xsl:text>
									</originalText>
									<value>
										<xsl:value-of select="$value"/>
										<xsl:value-of select="$valueNull"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:value/@displayName"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:interpretationCode/@code"/>
									</value>
									<triggered>
										<xsl:if test="cda:value/cda:translation[@codeSystem = '2.16.840.1.113883.6.90'][@code = $value]/@sdtc:valueSet">
											<xsl:text>Triggered in eCR</xsl:text>
										</xsl:if>
										<xsl:text>^</xsl:text>
									</triggered>
									<triggerMatch>
										<xsl:choose>
											<xsl:when test="document($SecondVersionXML)/all/Diagnosis/codes/code[@status = 'Active']/@code = $value">
												<xsl:text>Diagnosis Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/Diagnosis/codes/code[@status = 'Active'][@code = $value]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/Diagnosis/codes/code[@status = 'Active'][@code = $value]/@descriptor"/>
											</xsl:when>
											<xsl:when test="document($SecondVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active']/@code = $value">
												<xsl:text>Suspect Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active'][@code = $value]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active'][@code = $value]/@descriptor"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>No Trigger Match</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</triggerMatch>
								</record>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<record>
								<rctcVersion>
									<xsl:value-of select="$SecondVersionCheck"/>
								</rctcVersion>
								<scan>
									<xsl:text>No Problem Act Problem Observation ICD10 Translation</xsl:text>
								</scan>
								<ecrnumber>
									<xsl:value-of select="$ecrRoot"/>
									<xsl:text>^</xsl:text>
									<xsl:value-of select="$ecrExtension"/>
								</ecrnumber>
								<setId>
									<xsl:value-of select="$setId"/>
								</setId>
								<version>
									<xsl:value-of select="$version"/>
									<xsl:text>^</xsl:text>
								</version>
								<ecrDate>
									<xsl:value-of select="$ecrm"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecrd"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecry"/>
								</ecrDate>
								<custodian>
									<xsl:value-of select="$custodian"/>
									<xsl:text>^</xsl:text>
								</custodian>
								<facility>
									<xsl:value-of select="$facility"/>
									<xsl:text>^</xsl:text>
								</facility>
								<code>
									<xsl:text>No Problem Act Problem Observation ICD10 Translation</xsl:text>
								</code>
								<originalText>
									<xsl:text>No Problem Act Problem Observation ICD10 Translation</xsl:text>
								</originalText>
								<value>
									<xsl:text>No Problem Act Problem Observation ICD10 Translation</xsl:text>
								</value>
								<triggered>
									<xsl:text>No Problem Act Problem Observation ICD10 Translation</xsl:text>
								</triggered>
								<triggerMatch>
									<xsl:text>No Problem Act Problem Observation ICD10 Translation</xsl:text>
								</triggerMatch>
							</record>
						</xsl:otherwise>
					</xsl:choose>
					<!--ENCOUNTER DIAGNOSIS PROBLEM OBSERVATION VALUES-->
					<xsl:choose>
						<xsl:when test="//cda:act[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.80']/cda:entryRelationship/cda:observation[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.4']">
							<xsl:for-each select="//cda:act[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.80']/cda:entryRelationship/cda:observation[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.4']">
								<xsl:variable name="code" select="cda:code/@code"/>
								<xsl:variable name="codeNull" select="cda:code/@nullFlavor"/>
								<xsl:variable name="value" select="cda:value/@code"/>
								<xsl:variable name="valueNull" select="cda:value/@nullFlavor"/>
								<record>
									<rctcVersion>
										<xsl:value-of select="$SecondVersionCheck"/>
									</rctcVersion>
									<scan>
										<xsl:text>Encounter Diagnosis Problem Observation Values</xsl:text>
									</scan>
									<ecrnumber>
										<xsl:value-of select="$ecrRoot"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="$ecrExtension"/>
									</ecrnumber>
									<setId>
										<xsl:value-of select="$setId"/>
									</setId>
									<version>
										<xsl:value-of select="$version"/>
										<xsl:text>^</xsl:text>
									</version>
									<ecrDate>
										<xsl:value-of select="$ecrm"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecrd"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecry"/>
									</ecrDate>
									<custodian>
										<xsl:value-of select="$custodian"/>
										<xsl:text>^</xsl:text>
									</custodian>
									<facility>
										<xsl:value-of select="$facility"/>
										<xsl:text>^</xsl:text>
									</facility>
									<code>
										<!--<xsl:value-of select="$code"/>
						<xsl:value-of select="$codeNull"/>-->
										<xsl:text>^</xsl:text>
									</code>
									<originalText>
										<xsl:value-of select="normalize-space(cda:code/cda:originalText)"/>
										<xsl:text>^</xsl:text>
									</originalText>
									<value>
										<xsl:value-of select="$value"/>
										<xsl:value-of select="$valueNull"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:value/@displayName"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:interpretationCode/@code"/>
									</value>
									<triggered>
										<xsl:if test="cda:value[@code = $value]/@sdtc:valueSet">
											<xsl:text>Triggered in eCR</xsl:text>
										</xsl:if>
										<xsl:text>^</xsl:text>
									</triggered>
									<triggerMatch>
										<xsl:choose>
											<xsl:when test="document($SecondVersionXML)/all/Diagnosis/codes/code[@status = 'Active']/@code = $value">
												<xsl:text>Diagnosis Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/Diagnosis/codes/code[@status = 'Active'][@code = $value]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/Diagnosis/codes/code[@status = 'Active'][@code = $value]/@descriptor"/>
											</xsl:when>
											<xsl:when test="document($SecondVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active']/@code = $value">
												<xsl:text>Suspect Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active'][@code = $value]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active'][@code = $value]/@descriptor"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>No Trigger Match</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</triggerMatch>
								</record>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<record>
								<rctcVersion>
									<xsl:value-of select="$SecondVersionCheck"/>
								</rctcVersion>
								<scan>
									<xsl:text>No Encounter Diagnosis Problem Observation Values</xsl:text>
								</scan>
								<ecrnumber>
									<xsl:value-of select="$ecrRoot"/>
									<xsl:text>^</xsl:text>
									<xsl:value-of select="$ecrExtension"/>
								</ecrnumber>
								<setId>
									<xsl:value-of select="$setId"/>
								</setId>
								<version>
									<xsl:value-of select="$version"/>
									<xsl:text>^</xsl:text>
								</version>
								<ecrDate>
									<xsl:value-of select="$ecrm"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecrd"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecry"/>
								</ecrDate>
								<custodian>
									<xsl:value-of select="$custodian"/>
									<xsl:text>^</xsl:text>
								</custodian>
								<facility>
									<xsl:value-of select="$facility"/>
									<xsl:text>^</xsl:text>
								</facility>
								<code>
									<xsl:text>No Encounter Diagnosis Problem Observation Values</xsl:text>
								</code>
								<originalText>
									<xsl:text>No Encounter Diagnosis Problem Observation Values</xsl:text>
								</originalText>
								<value>
									<xsl:text>No Encounter Diagnosis Problem Observation Values</xsl:text>
								</value>
								<triggered>
									<xsl:text>No Encounter Diagnosis Problem Observation Values</xsl:text>
								</triggered>
								<triggerMatch>
									<xsl:text>No Encounter Diagnosis Problem Observation Values</xsl:text>
								</triggerMatch>
							</record>
						</xsl:otherwise>
					</xsl:choose>
					<!--CHIEF COMPLAINT VALUE-->
					<xsl:choose>
						<xsl:when test="//cda:observation[cda:code/@code = '8661-1']">
							<xsl:for-each select="//cda:observation[cda:code/@code = '8661-1']">
								<xsl:variable name="code" select="cda:code/@code"/>
								<xsl:variable name="codeNull" select="cda:code/@nullFlavor"/>
								<xsl:variable name="value" select="cda:value/@code"/>
								<xsl:variable name="valueNull" select="cda:value/@nullFlavor"/>
								<record>
									<rctcVersion>
										<xsl:value-of select="$SecondVersionCheck"/>
									</rctcVersion>
									<scan>
										<xsl:text>Chief Complaint Value</xsl:text>
									</scan>
									<ecrnumber>
										<xsl:value-of select="$ecrRoot"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="$ecrExtension"/>
									</ecrnumber>
									<setId>
										<xsl:value-of select="$setId"/>
									</setId>
									<version>
										<xsl:value-of select="$version"/>
										<xsl:text>^</xsl:text>
									</version>
									<ecrDate>
										<xsl:value-of select="$ecrm"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecrd"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecry"/>
									</ecrDate>
									<custodian>
										<xsl:value-of select="$custodian"/>
										<xsl:text>^</xsl:text>
									</custodian>
									<facility>
										<xsl:value-of select="$facility"/>
										<xsl:text>^</xsl:text>
									</facility>
									<code>
										<!--<xsl:value-of select="$code"/>
						<xsl:value-of select="$codeNull"/>-->
										<xsl:text>^</xsl:text>
									</code>
									<originalText>
										<xsl:value-of select="normalize-space(cda:code/cda:originalText)"/>
										<xsl:text>^</xsl:text>
									</originalText>
									<value>
										<xsl:value-of select="$value"/>
										<xsl:value-of select="$valueNull"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:value/@displayName"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:interpretationCode/@code"/>
									</value>
									<triggered>
										<xsl:if test="cda:value[@code = $value]/@sdtc:valueSet">
											<xsl:text>Triggered in eCR</xsl:text>
										</xsl:if>
										<xsl:text>^</xsl:text>
									</triggered>
									<triggerMatch>
										<xsl:choose>
											<xsl:when test="document($SecondVersionXML)/all/Diagnosis/codes/code[@status = 'Active']/@code = $value">
												<xsl:text>Diagnosis Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/Diagnosis/codes/code[@status = 'Active'][@code = $value]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/Diagnosis/codes/code[@status = 'Active'][@code = $value]/@descriptor"/>
											</xsl:when>
											<xsl:when test="document($SecondVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active']/@code = $value">
												<xsl:text>Suspect Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active'][@code = $value]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/SuspectedDisorder/codes/code[@status = 'Active'][@code = $value]/@descriptor"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>No Trigger Match</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</triggerMatch>
								</record>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<record>
								<rctcVersion>
									<xsl:value-of select="$SecondVersionCheck"/>
								</rctcVersion>
								<scan>
									<xsl:text>No Chief Complaint Value</xsl:text>
								</scan>
								<ecrnumber>
									<xsl:value-of select="$ecrRoot"/>
									<xsl:text>^</xsl:text>
									<xsl:value-of select="$ecrExtension"/>
								</ecrnumber>
								<setId>
									<xsl:value-of select="$setId"/>
								</setId>
								<version>
									<xsl:value-of select="$version"/>
									<xsl:text>^</xsl:text>
								</version>
								<ecrDate>
									<xsl:value-of select="$ecrm"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecrd"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecry"/>
								</ecrDate>
								<custodian>
									<xsl:value-of select="$custodian"/>
									<xsl:text>^</xsl:text>
								</custodian>
								<facility>
									<xsl:value-of select="$facility"/>
									<xsl:text>^</xsl:text>
								</facility>
								<code>
									<xsl:text>No Chief Complaint Value</xsl:text>
								</code>
								<originalText>
									<xsl:text>No Chief Complaint Value</xsl:text>
								</originalText>
								<value>
									<xsl:text>No Chief Complaint Value</xsl:text>
								</value>
								<triggered>
									<xsl:text>No Chief Complaint Value</xsl:text>
								</triggered>
								<triggerMatch>
									<xsl:text>No Chief Complaint Value</xsl:text>
								</triggerMatch>
							</record>
						</xsl:otherwise>
					</xsl:choose>
					<!--ORGANISM VALUE-->
					<xsl:choose>
						<xsl:when test="//cda:entry/cda:organizer[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.1']/cda:component/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.2']">
							<xsl:for-each select="//cda:entry/cda:organizer[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.1']/cda:component/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.22.4.2']">
								<xsl:variable name="code" select="cda:code/@code"/>
								<xsl:variable name="codeNull" select="cda:code/@nullFlavor"/>
								<xsl:variable name="value" select="cda:value/@code"/>
								<xsl:variable name="valueNull" select="cda:value/@nullFlavor"/>
								<record>
									<rctcVersion>
										<xsl:value-of select="$SecondVersionCheck"/>
									</rctcVersion>
									<scan>
										<xsl:text>Result Observation Organism Value</xsl:text>
									</scan>
									<ecrnumber>
										<xsl:value-of select="$ecrRoot"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="$ecrExtension"/>
									</ecrnumber>
									<setId>
										<xsl:value-of select="$setId"/>
									</setId>
									<version>
										<xsl:value-of select="$version"/>
										<xsl:text>^</xsl:text>
									</version>
									<ecrDate>
										<xsl:value-of select="$ecrm"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecrd"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecry"/>
									</ecrDate>
									<custodian>
										<xsl:value-of select="$custodian"/>
										<xsl:text>^</xsl:text>
									</custodian>
									<facility>
										<xsl:value-of select="$facility"/>
										<xsl:text>^</xsl:text>
									</facility>
									<code>
										<xsl:value-of select="$code"/>
										<xsl:value-of select="$codeNull"/>
										<xsl:text>^</xsl:text>
									</code>
									<originalText>
										<xsl:value-of select="normalize-space(cda:code/cda:originalText)"/>
										<xsl:text>^</xsl:text>
									</originalText>
									<value>
										<xsl:value-of select="$value"/>
										<xsl:value-of select="$valueNull"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:value/@displayName"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:interpretationCode/@code"/>
									</value>
									<triggered>
										<xsl:if test="cda:value[@code = $value]/@sdtc:valueSet">
											<xsl:text>Triggered in eCR</xsl:text>
										</xsl:if>
										<xsl:text>^</xsl:text>
									</triggered>
									<triggerMatch>
										<xsl:choose>
											<xsl:when test="document($SecondVersionXML)/all/Organism/codes/code[@status = 'Active']/@code = $value">
												<xsl:text>Organism Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/Organism/codes/code[@status = 'Active'][@code = $value]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/Organism/codes/code[@status = 'Active'][@code = $value]/@descriptor"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>No Trigger Match</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</triggerMatch>
								</record>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<record>
								<rctcVersion>
									<xsl:value-of select="$SecondVersionCheck"/>
								</rctcVersion>
								<scan>
									<xsl:text>Result Observation Organism Value</xsl:text>
								</scan>
								<ecrnumber>
									<xsl:value-of select="$ecrRoot"/>
									<xsl:text>^</xsl:text>
									<xsl:value-of select="$ecrExtension"/>
								</ecrnumber>
								<setId>
									<xsl:value-of select="$setId"/>
								</setId>
								<version>
									<xsl:value-of select="$version"/>
									<xsl:text>^</xsl:text>
								</version>
								<ecrDate>
									<xsl:value-of select="$ecrm"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecrd"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecry"/>
								</ecrDate>
								<custodian>
									<xsl:value-of select="$custodian"/>
									<xsl:text>^</xsl:text>
								</custodian>
								<facility>
									<xsl:value-of select="$facility"/>
									<xsl:text>^</xsl:text>
								</facility>
								<code>
									<xsl:text>No Result Observations</xsl:text>
								</code>
								<originalText>
									<xsl:text>No Result Observations</xsl:text>
								</originalText>
								<value>
									<xsl:text>No Result Observations</xsl:text>
								</value>
								<triggered>
									<xsl:text>No Result Observations</xsl:text>
								</triggered>
								<triggerMatch>
									<xsl:text>No Result Observations</xsl:text>
								</triggerMatch>
							</record>
						</xsl:otherwise>
					</xsl:choose>
					<!--PLANNED OBSERVATION CODE-->
					<xsl:choose>
						<xsl:when test="//cda:observation[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.44']">
							<xsl:for-each select="//cda:observation[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.44']">
								<xsl:variable name="code" select="cda:code/@code"/>
								<xsl:variable name="codeNull" select="cda:code/@nullFlavor"/>
								<xsl:variable name="value" select="cda:value/@code"/>
								<xsl:variable name="valueNull" select="cda:value/@nullFlavor"/>
								<record>
									<rctcVersion>
										<xsl:value-of select="$SecondVersionCheck"/>
									</rctcVersion>
									<scan>
										<xsl:text>Planned Observation Codes</xsl:text>
									</scan>
									<ecrnumber>
										<xsl:value-of select="$ecrRoot"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="$ecrExtension"/>
									</ecrnumber>
									<setId>
										<xsl:value-of select="$setId"/>
									</setId>
									<version>
										<xsl:value-of select="$version"/>
										<xsl:text>^</xsl:text>
									</version>
									<ecrDate>
										<xsl:value-of select="$ecrm"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecrd"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecry"/>
									</ecrDate>
									<custodian>
										<xsl:value-of select="$custodian"/>
										<xsl:text>^</xsl:text>
									</custodian>
									<facility>
										<xsl:value-of select="$facility"/>
										<xsl:text>^</xsl:text>
									</facility>
									<code>
										<xsl:value-of select="$code"/>
										<xsl:value-of select="$codeNull"/>
										<xsl:text>^</xsl:text>
									</code>
									<originalText>
										<xsl:value-of select="normalize-space(cda:code/cda:originalText)"/>
										<xsl:text>^</xsl:text>
									</originalText>
									<value>
										<xsl:value-of select="$value"/>
										<xsl:value-of select="$valueNull"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:value/@displayName"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:interpretationCode/@code"/>
									</value>
									<triggered>
										<xsl:if test="cda:code[@code = $code]/@sdtc:valueSet">
											<xsl:text>Triggered in eCR</xsl:text>
										</xsl:if>
										<xsl:text>^</xsl:text>
									</triggered>
									<triggerMatch>
										<xsl:choose>
											<xsl:when test="document($SecondVersionXML)/all/LabOrder/codes/code[@status = 'Active']/@code = $code">
												<xsl:text>Planned Obs Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/LabOrder/codes/code[@status = 'Active'][@code = $code]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/LabOrder/codes/code[@status = 'Active'][@code = $code]/@descriptor"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>No Trigger Match</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</triggerMatch>
								</record>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<record>
								<rctcVersion>
									<xsl:value-of select="$SecondVersionCheck"/>
								</rctcVersion>
								<scan>
									<xsl:text>No Planned Observations</xsl:text>
								</scan>
								<ecrnumber>
									<xsl:value-of select="$ecrRoot"/>
									<xsl:text>^</xsl:text>
									<xsl:value-of select="$ecrExtension"/>
								</ecrnumber>
								<setId>
									<xsl:value-of select="$setId"/>
								</setId>
								<version>
									<xsl:value-of select="$version"/>
									<xsl:text>^</xsl:text>
								</version>
								<ecrDate>
									<xsl:value-of select="$ecrm"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecrd"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecry"/>
								</ecrDate>
								<custodian>
									<xsl:value-of select="$custodian"/>
									<xsl:text>^</xsl:text>
								</custodian>
								<facility>
									<xsl:value-of select="$facility"/>
									<xsl:text>^</xsl:text>
								</facility>
								<code>
									<xsl:text>No Planned Observations</xsl:text>
								</code>
								<originalText>
									<xsl:text>No Planned Observations</xsl:text>
								</originalText>
								<value>
									<xsl:text>No Planned Observations</xsl:text>
								</value>
								<triggered>
									<xsl:text>No Planned Observations</xsl:text>
								</triggered>
								<triggerMatch>
									<xsl:text>No Planned Observations</xsl:text>
								</triggerMatch>
							</record>
						</xsl:otherwise>
					</xsl:choose>
					<!--MEDICATION CODES-->
					<xsl:choose>
						<xsl:when test="//cda:substanceAdministration[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.16']">
							<xsl:for-each select="//cda:substanceAdministration[cda:templateId/@root = '2.16.840.1.113883.10.20.22.4.16']">
								<xsl:variable name="code" select="cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code/@code"/>
								<xsl:variable name="codeNull" select="cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code/@nullFlavor"/>
								<xsl:variable name="value" select="cda:value/@code"/>
								<xsl:variable name="valueNull" select="cda:value/@nullFlavor"/>
								<record>
									<rctcVersion>
										<xsl:value-of select="$SecondVersionCheck"/>
									</rctcVersion>
									<scan>
										<xsl:text>Medication Codes</xsl:text>
									</scan>
									<ecrnumber>
										<xsl:value-of select="$ecrRoot"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="$ecrExtension"/>
									</ecrnumber>
									<setId>
										<xsl:value-of select="$setId"/>
									</setId>
									<version>
										<xsl:value-of select="$version"/>
										<xsl:text>^</xsl:text>
									</version>
									<ecrDate>
										<xsl:value-of select="$ecrm"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecrd"/>
										<xsl:text>/</xsl:text>
										<xsl:value-of select="$ecry"/>
									</ecrDate>
									<custodian>
										<xsl:value-of select="$custodian"/>
										<xsl:text>^</xsl:text>
									</custodian>
									<facility>
										<xsl:value-of select="$facility"/>
										<xsl:text>^</xsl:text>
									</facility>
									<code>
										<xsl:value-of select="$code"/>
										<xsl:value-of select="$codeNull"/>
										<xsl:text>^</xsl:text>
									</code>
									<originalText>
										<xsl:value-of select="normalize-space(cda:code/cda:originalText)"/>
										<xsl:text>^</xsl:text>
									</originalText>
									<value>
										<xsl:value-of select="$value"/>
										<xsl:value-of select="$valueNull"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:value/@displayName"/>
										<xsl:text>^</xsl:text>
										<xsl:value-of select="cda:interpretationCode/@code"/>
									</value>
									<triggered>
										<xsl:if test="cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/cda:code[@code = $code]/@sdtc:valueSet">
											<xsl:text>Triggered in eCR</xsl:text>
										</xsl:if>
										<xsl:text>^</xsl:text>
									</triggered>
									<triggerMatch>
										<xsl:choose>
											<xsl:when test="document($SecondVersionXML)/all/Medication/codes/code[@status = 'Active']/@code = $code">
												<xsl:text>Medication Trigger Code Match|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/Medication/codes/code[@status = 'Active'][@code = $code]/@memberOID"/>
												<xsl:text>|</xsl:text>
												<xsl:value-of select="document($SecondVersionXML)/all/Medication/codes/code[@status = 'Active'][@code = $code]/@descriptor"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>No Trigger Match</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</triggerMatch>
								</record>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<record>
								<rctcVersion>
									<xsl:value-of select="$SecondVersionCheck"/>
								</rctcVersion>
								<scan>
									<xsl:text>No Medication Codes</xsl:text>
								</scan>
								<ecrnumber>
									<xsl:value-of select="$ecrRoot"/>
									<xsl:text>^</xsl:text>
									<xsl:value-of select="$ecrExtension"/>
								</ecrnumber>
								<setId>
									<xsl:value-of select="$setId"/>
								</setId>
								<version>
									<xsl:value-of select="$version"/>
									<xsl:text>^</xsl:text>
								</version>
								<ecrDate>
									<xsl:value-of select="$ecrm"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecrd"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="$ecry"/>
								</ecrDate>
								<custodian>
									<xsl:value-of select="$custodian"/>
									<xsl:text>^</xsl:text>
								</custodian>
								<facility>
									<xsl:value-of select="$facility"/>
									<xsl:text>^</xsl:text>
								</facility>
								<code>
									<xsl:text>No Medication Codes</xsl:text>
								</code>
								<originalText>
									<xsl:text>No Medication Codes</xsl:text>
								</originalText>
								<value>
									<xsl:text>No Medication Codes</xsl:text>
								</value>
								<triggered>
									<xsl:text>No Medication Codes</xsl:text>
								</triggered>
								<triggerMatch>
									<xsl:text>No Medication Codes</xsl:text>
								</triggerMatch>
							</record>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<!--NO RCTC VERSION MATCH-->
				<xsl:otherwise>
					<record>
						<rctcVersion>
							<xsl:text>RCTC Does Not Match: </xsl:text>
							<xsl:value-of select="$FirstVersionCheck"/>
							<xsl:text> or </xsl:text>
							<xsl:value-of select="$SecondVersionCheck"/>
						</rctcVersion>
						<scan>
							<xsl:text>RCTC Version: </xsl:text>
							<xsl:value-of select="//cda:*/@sdtc:valueSetVersion"/>
						</scan>
						<ecrnumber>
							<xsl:value-of select="$ecrRoot"/>
							<xsl:text>^</xsl:text>
							<xsl:value-of select="$ecrExtension"/>
						</ecrnumber>
						<setId>
							<xsl:value-of select="$setId"/>
						</setId>
						<version>
							<xsl:value-of select="$version"/>
							<xsl:text>^</xsl:text>
						</version>
						<ecrDate>
							<xsl:value-of select="$ecrm"/>
							<xsl:text>/</xsl:text>
							<xsl:value-of select="$ecrd"/>
							<xsl:text>/</xsl:text>
							<xsl:value-of select="$ecry"/>
						</ecrDate>
						<custodian>
							<xsl:value-of select="$custodian"/>
							<xsl:text>^</xsl:text>
						</custodian>
						<facility>
							<xsl:value-of select="$facility"/>
							<xsl:text>^</xsl:text>
						</facility>
						<code>
							<xsl:text>No RCTC Version Match</xsl:text>
						</code>
						<originalText>
							<xsl:text>No RCTC Version Match</xsl:text>
						</originalText>
						<value>
							<xsl:text>No RCTC Version Match</xsl:text>
						</value>
						<triggered>
							<xsl:text>No RCTC Version Match</xsl:text>
						</triggered>
						<triggerMatch>
							<xsl:text>No RCTC Version Match</xsl:text>
						</triggerMatch>
					</record>
				</xsl:otherwise>
			</xsl:choose>
		</data>
	</xsl:template>
</xsl:stylesheet>