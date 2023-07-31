# IaC_Project

The following code disposes a fast implementation of a website on IIS following the characteristics specified below with a yml pipeline.
This pipeline does the following: 

  
  -Checks for IIS roles and configuration if it dosnt detect them it will automatically install them.
  
  
  -Creates an application pool for the website.
  
  
  -Creates a website

  
  -Creates a virtual directory for said website
  
  
  -Modifies default document allowed parameters to add Index.aspx as an option.
  
  
  -Syncs the default document with a document available on my devops repository.
  
  
  -Creates a binding on 8087.
