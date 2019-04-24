# Ebola Care Guidelines app

This app offers evidence-based guidelines for the care and management for Ebola Virus Disease (EVD) patients. It also incorporates machine learning prognostic models to calculate the severity risk of a patient at triage based on the demographics information, clinical signs and symptoms, and available laboratory results. The manuscript describing the prognostic models is available as a [pre-print on bioRxiv](https://www.biorxiv.org/content/10.1101/294587v5), and the app itself can be freely installed on any Android device from [Google Play Store](https://play.google.com/store/apps/details?id=org.broadinstitute.ebola_care_guidelines). 

The sections below provide an overview of the app's functionality, and the [wiki section](https://github.com/broadinstitute/ebola-care-guidelines/wiki) describes how to customize the app with new models and guidelines.

## Using the app

Upon launching the Ebola Care Guidelines app, it will present a scrollable list of recommendations for the care of management of EVD patients across across different categories:

<img src="https://github.com/broadinstitute/ebola-care-guidelines/blob/master/images/homescreen.png" width="300"/>

After selecting any category, another screen will open up providing more in-depth information about the selected recommendation, and specific intervention guides related to the recommendation:

<img src="https://github.com/broadinstitute/ebola-care-guidelines/blob/master/images/parenteral_fluids.png" width="300"/>

Clicking on an intervention guide will direct the user to the corresponding page in either the [Clinical management of patients with viral haemorrhagic fever](https://www.who.int/csr/resources/publications/clinical-management-patients/en/) or the [Manual for the care and management of patients in Ebola Care Units/Community Care Centres](http://www.who.int/csr/resources/publications/ebola/patient-care-CCUs/en) describing that intervention in detail:

<img src="https://github.com/broadinstitute/ebola-care-guidelines/blob/master/images/iv_vs_ors_chart.png" width="300"/>

## Entering patient information

The app can be used simply to access WHO's recommendations and intervention guides from a smartphone, but it offers the possibility of calculating a severity score of a patient at triage based on the available information (demographics, clinical features, laboratory data). This inforamtion can be entered into the app using two different methods: a default data-entry form or with a complementary CommCare app.

### Using the default data-entry form

The default data-entry form is accessed by clicking on the "Enter Patient Data" button. This form comprises four tabs: 

1. Patient (basic information including demographics and physical measures) 

<img src="https://github.com/broadinstitute/ebola-care-guidelines/blob/master/images/patient_tab.png" width="300"/>

2. Triage (clinical signs and symptoms recorded at triage) 

<img src="https://github.com/broadinstitute/ebola-care-guidelines/blob/master/images/triage_tab.png" width="300"/>

3. Lab (laboratory results, PCR and malaria test)

<img src="https://github.com/broadinstitute/ebola-care-guidelines/blob/master/images/lab_tab.png" width="300"/>

The PCR results include not only the CT value, but the overall mean and standard deviation of the CT from the cases seen at the site, depending on the PCR assay in use. This is needed to perform "feature scaling" and normalize the CT values so they can entered into the prognostic models, which are not-site specific.

4. Wellness (an observational wellness assessment)

<img src="https://github.com/broadinstitute/ebola-care-guidelines/blob/master/images/wellness_tab.png" width="300"/>

There is no need to enter all the information, depending on what's available, the app will use a prognostic model to calculate a severity score for the patient. The numerical value of the score will be displayed at the top of the home screen:

<img src="https://github.com/broadinstitute/ebola-care-guidelines/blob/master/images/score.png" width="300"/>

Certain recommendations are be highlighted depending on which signs/symptoms are present, e.g.: oral dehydration is highlighted if the patient presents with nausea, diarrhoea , loss of appetite, haemorrhagic eyes, bloody diarrhoea, or confusion, or wellness scale is equal or higher than 4.

### Using the CommCare data-entry app

[CommCare](https://www.dimagi.com/commcare/) is a platform to build data-collection apps. CommCare apps are defined through XML files that specifiy the forms (for example, triage) that make up a cases (for example, an incoming patients). These XML  files get compiled as Android apps that can be distributed among the team tasked with a particular data-collection campaign. 
CommCare apps first store the data locally on the device and then upload them to a secure, HIPPA-compliant cloud server. It is required to have a [CommCareHQ account](https://www.commcarehq.org/accounts/login/) in order to create and deploy data-collection apps.

Ebola Care Guidelines can retrieve data from a CommCare app collecting the variables defined in the default data-entry form described before. This CommCare app is not provided for installation, but the [commcare folder](https://github.com/broadinstitute/ebola-care-guidelines/tree/master/commcare) in the repo provides the XML files specifying the two forms needed in this app: the patient registration form (where all the variables seen above get entered) and the follow-up form (to enter the final disposition of the patient). These XML files can be loaded into a CommCareHQ account to build the data-entry app. Once this app is installed in the device, the settings have to be changed to switch from the default data-entry form to the CommCare app:

<img src="https://github.com/broadinstitute/ebola-care-guidelines/blob/master/images/commcare_settings.png" width="900"/>

To open the CommCare app from the Ebola Care Guidelines app, the same "Enter Patient Data" button is to be clicked. The first time this is done, the following sequence of screens will show up, with the middle one asking for permission to read the data from the CommCare app:

<img src="https://github.com/broadinstitute/ebola-care-guidelines/blob/master/images/commcare_intro.png" width="900"/>

The "Use CommCare to" menu allows to enter a brand new case or to lookup an existing case, which is convenient since it allows to run the severity score calculation on existing data wihout having to enter it again (which is what happens with the default built-in form). Creating a new case opens the CommCare app where the same variables shown before are entered in succesive screens:



A CommCare case is no longer available on the device once the final disposition is entered into the CommCare app.




