drop table "UserTransLink";
drop table "UserTransLinkHistory";

alter table "TranslationLink" add column "ToBeInterrogated" boolean;
alter table "TranslationLink" add column "ToBeInterrogatedInWriting" boolean;
alter table "TranslationLink" add column "ToBeInterrogatedFrom" date;


CREATE TABLE "Interrogation" (
	"InterrogationId" bigint NOT NULL GENERATED ALWAYS AS IDENTITY,
	"UnitTreeId" bigint NOT NULL,
	"UserId" bigint NOT NULL,
	"InWriting" boolean NOT NULL,
	"StartTime" date NOT null,
	CONSTRAINT "Interrogation_pkey" PRIMARY KEY ("InterrogationId")
);

ALTER TABLE "Interrogation" ADD CONSTRAINT "FK_UnitTreeId" FOREIGN KEY ("UnitTreeId") REFERENCES "UnitTree"("UnitTreeId");
ALTER TABLE "Interrogation" ADD CONSTRAINT "FK_UserId" FOREIGN KEY ("UserId") REFERENCES "User"("UserId");

CREATE TABLE "Answer" (
	"AnswerId" bigint NOT NULL GENERATED ALWAYS AS IDENTITY,
	"TranslationLinkId" bigint NOT NULL,
	"UserId" bigint NOT NULL,
	"InterrogationId" bigint NOT NULL,
	"RithAnswer" boolean NOT NULL,
	"AnswerTime" date NOT null,
	CONSTRAINT "Answer_pkey" PRIMARY KEY ("AnswerId")
);

ALTER TABLE "Answer" ADD CONSTRAINT "FK_InterrogationId" FOREIGN KEY ("InterrogationId") REFERENCES "Interrogation"("InterrogationId");
ALTER TABLE "Answer" ADD CONSTRAINT "FK_UserId" FOREIGN KEY ("UserId") REFERENCES "User"("UserId");
ALTER TABLE "Answer" ADD CONSTRAINT "FK_TranslationLinkId" FOREIGN KEY ("TranslationLinkId") REFERENCES "TranslationLink"("TranslationLinkId");

CREATE TABLE "AnswerHistory" (
	"AnswerHistoryId" bigint NOT NULL GENERATED ALWAYS AS IDENTITY,
	"TranslationLinkId" bigint NOT NULL,
	"UserId" bigint NOT NULL,
	"InterrogationId" bigint NOT NULL,
	"RithAnswer" boolean NOT NULL,
	"AnswerTime" date NOT null,
	CONSTRAINT "AnswerHistory_pkey" PRIMARY KEY ("AnswerHistoryId")
);

ALTER TABLE "AnswerHistory" ADD CONSTRAINT "FK_InterrogationId" FOREIGN KEY ("InterrogationId") REFERENCES "Interrogation"("InterrogationId");
ALTER TABLE "AnswerHistory" ADD CONSTRAINT "FK_UserId" FOREIGN KEY ("UserId") REFERENCES "User"("UserId");
ALTER TABLE "AnswerHistory" ADD CONSTRAINT "FK_TranslationLinkId" FOREIGN KEY ("TranslationLinkId") REFERENCES "TranslationLink"("TranslationLinkId");
