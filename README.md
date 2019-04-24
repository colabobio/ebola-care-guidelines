# Ebola Care Guidelines app

This app offers evidence-based guidelines for the care and management for Ebola Virus Disease (EVD) patients. It also incorporates machine learning prognostic models to calculate the severity risk of a patient at triage based on the demographics information, clinical signs and symptoms, and available laboratory results. The manuscript describing the prognostic models is available as a [pre-print on bioRxiv](https://www.biorxiv.org/content/10.1101/294587v5), and the app itself can be freely installed on any Android device from [Google Play Store](https://play.google.com/store/apps/details?id=org.broadinstitute.ebola_care_guidelines). 

The sections below provide an overview of the app's functionality, and the [wiki section](https://github.com/broadinstitute/ebola-care-guidelines/wiki) describes how to customize the app with new models and guidelines.

## Using the app

Upon launching the Ebola Care Guidelines app, it will present a scrollable list of recommendations for the care of management of EVD patients across across different categories:

<img src="https://github.com/broadinstitute/ebola-care-guidelines/blob/master/images/homescreen.png" width="400"/>

After selecting any category, another screen will open up providing more in-depth information about the selected recommendation, and specific intervention guides related to the recommendation:

<img src="https://github.com/broadinstitute/ebola-care-guidelines/blob/master/images/parenteral_fluids.png" width="400"/>

Clicking on an intervention guide will direct the user to the corresponding page in either the [Clinical management of patients with viral haemorrhagic fever](https://www.who.int/csr/resources/publications/clinical-management-patients/en/) or the [Manual for the care and management of patients in Ebola Care Units/Community Care Centres](http://www.who.int/csr/resources/publications/ebola/patient-care-CCUs/en) describing that intervention in detail:

<img src="https://github.com/broadinstitute/ebola-care-guidelines/blob/master/images/iv_vs_ors_chart.png" width="400"/>

## Entering patient information

The app can be used simply to access WHO's recommendations and intervention guides from a smartphone, but it offers the possibility of calculating a severity score of a patient at triage based on the available information (demographics, clinical features, laboratory data). This inforamtion can be entered into the app using two different methods: a default data-entry form or with a complementary CommCare app.

### Using the default data-entry form

The default data-entry form is accessed by clicking on the "Enter Patient Data" button. This form comprises four tabs: 

1. Patient (basic information including demographics and physical measures) 

<img src="https://github.com/broadinstitute/ebola-care-guidelines/blob/master/images/patient_tab.png" width="400"/>

2. Triage (clinical signs and symptoms recorded at triage) 

<img src="https://github.com/broadinstitute/ebola-care-guidelines/blob/master/images/triage_tab.png" width="400"/>

3. Lab (laboratory results, PCR and malaria test)

<img src="https://github.com/broadinstitute/ebola-care-guidelines/blob/master/images/lab_tab.png" width="400"/>

4. Wellness (an observational wellness assessment)

<img src="https://github.com/broadinstitute/ebola-care-guidelines/blob/master/images/wellness_tab.png" width="400"/>

There is no need to enter all the information, depending on what's available, the app will use a prognostic model to calculate a severity score for the patient. The numerical value of the score will be displayed at the top of the home screen:

<img src="https://github.com/broadinstitute/ebola-care-guidelines/blob/master/images/score.png" width="300"/>

Certain recommendations are be highlighted depending on which signs/symptoms are present, e.g.: oral dehydration is highlighted if the patient presents with nausea, diarrhoea , loss of appetite, haemorrhagic eyes, bloody diarrhoea, or confusion, or wellness scale is equal or higher than 4.

### Using the CommCare data-entry app





