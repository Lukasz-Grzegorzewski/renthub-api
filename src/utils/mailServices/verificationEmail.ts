import jwt from 'jsonwebtoken';
import { sendEmail, EmailOptions } from './nodeMailer';
import { EmailTemplateParams, createEmailTemplate } from './emailTemplate';

export const sendVerificationEmail = async (
	userEmail: string,
	userFirstName: string
) => {
	const token = jwt.sign(
		{ email: userEmail, firstName: userFirstName },
		process.env.JWT_VERIFY_EMAIL_SECRET_KEY || '',
		{ expiresIn: '12h' }
	);

	const verificationLink = `${process.env.FRONTEND_URL}/verify-email?token=${token}`;

	const emailParams: EmailTemplateParams = {
		content: `<div class="header">
    Bonjour ${userFirstName},
  </div>
  <div class="content">
    <p>Cliquez sur le bouton ci-dessous pour valider votre inscription et rejoindre notre communauté !</p>
    <a href="${verificationLink}" class="button">Vérifiez votre email</a>
  </div>
  <div class="footer">
    Si vous n'avez pas demandé cette inscription, veuillez ignorer cet email.
  </div>`,
		title: 'Finalisez votre inscription sur RentHub',
	};

	const emailHtml = createEmailTemplate(emailParams);

	const emailOptions: EmailOptions = {
		from: process.env.MAIL_USER || 'contact@renthub.shop',
		to: userEmail || '',
		subject: 'Finalisez votre inscription sur RentHub',
		html: emailHtml,
	};

	try {
		const info = await sendEmail(emailOptions);
		return info;
	} catch (error) {
		throw new Error(`Error sending verification email: ${error}`);
	}
};

export const sendConfirmationEmail = async (
	userEmail: string,
	userFirstName: string
) => {
	const frontLink = `${process.env.FRONTEND_URL}/connexion`;

	const emailParams: EmailTemplateParams = {
		content: `<div class="header">
    Bonjour ${userFirstName},
    </div>
    <div class="content">
    <p>Votre email est vérifié et votre compte crée !</p>
    <p>Ne perdez pas un seul instant et postez une annonce directement en cliquant sur le lien ci-dessous :</p>
    <a href="${frontLink}" class="button">Créer une annonce</a>
    </div>
    <div class="footer">
    Si vous n'avez pas demandé cette inscription, veuillez ignorer cet email.
    </div>`,
		title: 'Email vérifié et compte crée !',
	};

	const emailHtml = createEmailTemplate(emailParams);

	const emailOptions: EmailOptions = {
		from: process.env.MAIL_USER || 'contact@renthub.shop',
		to: userEmail || '',
		subject: 'Bienvenue sur RentHub !',
		html: emailHtml,
	};

	try {
		const info = await sendEmail(emailOptions);
		return info;
	} catch (error) {
		throw new Error(`Error sending verification email: ${error}`);
	}
};
