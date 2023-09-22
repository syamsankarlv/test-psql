create or replace procedure proc_lmslos_select(p_flag in varchar2,
                                            p_pageval in varchar2,
                                            p_parval1 in varchar2,
                                            p_parval2 in varchar2,
                                            p_parval3 in varchar2,
                                            qry_result in OUT RESULT_TYPE.QRY_RESULT) is
cnt             number;
v_dtl1          array;
v_dtl2          array;
p_OutMsg     varchar2(200);
error_status   varchar2(200);
error_message  varchar2(200);
v_dtl15 array;
chk number;
begin
   if p_flag= 'FORMACCESS' then
    if p_pageval='CHECKLISTSCORECARDACCESS' then
       open QRY_RESULT for
    select count(*) into chk  from form_accessibility t  where t.emp_id=p_parval1 and t.form_id=5266;
    elsif p_pageval='MORATORIUMACCESS' then
          open QRY_RESULT for
          select count(*)  from form_accessibility t  where t.emp_id= p_parval1  and t.form_id=5241;
   elsif p_pageval='EXCEPTION_ACCESS' then
          open QRY_RESULT for
          select count(*)  from form_accessibility t  where t.emp_id= p_parval1  and t.form_id=5535;
  elsif p_pageval='ACHPDCUPDATIONRQT' then
         open QRY_RESULT for
         select count(*)  from form_accessibility t  where t.emp_id= p_parval1  and t.form_id=1200;
   elsif  p_pageval='ACHPDCUPDATIONAPR' then
         open QRY_RESULT for
         select count(*)  from form_accessibility t  where t.emp_id= p_parval1  and t.form_id=5067;
    elsif  p_pageval='LIENMARKRQST' then
         open QRY_RESULT for
         select count(*)  from form_accessibility t  where t.emp_id= p_parval1  and t.form_id=5566;
    elsif  p_pageval='LIENMARKAPRVL' then
         open QRY_RESULT for
         select count(*)  from form_accessibility t  where t.emp_id= p_parval1  and t.form_id=5567;
    elsif  p_pageval='POST_DISBURSED' then
         open QRY_RESULT for
         select count(*)  from form_accessibility t  where t.emp_id= p_parval1  and t.form_id=5655;

  elsif  p_pageval='POST_DISBURSED_REPORT' then
         open QRY_RESULT for
         select count(*)  from form_accessibility t  where t.emp_id= p_parval1  and t.form_id=5656;


      elsif p_pageval='RISK_CATEG_REPORT_ACCESS' then
          open QRY_RESULT for
          select count(*)  from form_accessibility t  where t.emp_id= p_parval1  and t.form_id=5668;

  elsif p_pageval='RISK_CATEG_ACCESS' then
          open QRY_RESULT for
          select count(*)  from form_accessibility t  where t.emp_id= p_parval1  and t.form_id=6164;
  elsif p_pageval='ADVACATE_updation_ACCESS' then
          open QRY_RESULT for
          select count(*)  from form_accessibility t  where t.emp_id= p_parval1  and t.form_id=6165;
  elsif p_pageval='ADVACATE_ACCESS' then
          v_dtl15      := splitstr(p_parval1, '?');

          open QRY_RESULT for
          select count(*)  from form_accessibility t  where t.emp_id= v_dtl15(1)  and t.form_id=7000;

   end if;
    end if;
  if p_Flag='MENUACCESS' then
          PROC_LMS_MENU(p_PageVal,p_parval1,p_parval2,QRY_RESULT);
  elsif p_Flag='LOANSETTLEMENT' then
       proc_branch_Loan_collection(p_pageval,p_parval1,p_parval2,qry_result);
   elsif p_Flag='DOCUMENTUPLOAD' then
       proc_loan_document(p_pageval,p_parval1, p_parval2,QRY_RESULT);
   elsif p_Flag='EXCEPTION' then
       proc_exception_custid_block(p_pageval,p_parval1,p_parval2,QRY_RESULT);
      elsif p_Flag='GetLoanType' then
       Proc_frmPaymentCustomRelase(p_pageval,p_parval1,p_parval2,p_parval3,QRY_RESULT);

      elsif p_flag='ADDPRODUCTDATA' then
       proc_loan_product_schema(p_pageval,p_parval1,QRY_RESULT);
   elsif p_flag='LOANREPORT' then
   proc_loan_product_report(p_pageval,p_parval1,p_parval2,p_parval3,QRY_RESULT);
   elsif p_Flag='BRANCH_INVENTORY_REPORT' then
    proc_Branch_inventory_report(p_flag,p_pageval, p_parval1, p_parval2,p_parval3 , QRY_RESULT);
  elsif p_flag='ADDPROPARAMETER' or p_flag='getmainpara' or  p_flag='ADDSUBPARA' or p_flag='GETLEAD' or  p_flag='submitpara' or p_flag='submitbank'or p_flag='showaddedpara' then
        PROC_ADD_PRO_PARAMETERS(p_flag, p_pageval, p_parval1,p_parval2, QRY_RESULT);

  elsif p_flag='LMSVOUCHER' then
    if p_pageval='VOUCHER_DTL' then
      OPEN QRY_RESULT FOR
      select c.firm_name as firm_name,substr(d.branch_name,0,20) as branch_name,a.trans_id as tno,a.account_no as  accno,substr(b.account_name,0,25) as accname,substr(a.descr,0,20) as  descr,nvl(decode(type,'D',a.amount),0) as debit,nvl(decode(type,'C',a.amount),0) as  credit,nvl(substr(a.narration,0,70),'Nil') as nar from transaction_detail a,account_profile b,firm_master c,branch_master d where a.firm_id=c.firm_id and a.branch_id=d.branch_id and b.ho_status<>1 and a.account_no=b.account_no and a.trans_id=p_parval2 and a.branch_id= element(p_parval1,1,'~') and a.firm_id= element(p_parval1,2,'~');
   elsif p_pageval='CASH_DTL' then
      select count(*) into cnt from cash_transaction t where t.trans_id=p_parval2 and t.branch_id=element(p_parval1,1,'~') and t.firm_id=element(p_parval1,2,'~');
      if cnt>0 then
         OPEN QRY_RESULT FOR
         select nvl(min(t.cash_id),0) from cash_transaction t where t.trans_id=p_parval2 and t.branch_id=element(p_parval1,1,'~') and t.firm_id=element(p_ParVal1,2,'~');
      else
         OPEN QRY_RESULT FOR
         select 0 cashid from dual;
      end if;
    elsif p_PageVal='CUR_TIME' then
      OPEN QRY_RESULT FOR
      select to_char(sysdate,'dd-MM-yyyy'),to_char(sysdate,'HH:MI:SS AM') from dual;

    end if;
    /* elsif p_flag='excelupload' then
     proc_lmslos_confirm(p_flag,p_pageval,p_parval1,p_parval2,p_parval3,p_OutMsg);
     open qry_result for
     select p_OutMsg from dual;
     
      elsif p_flag='nach_insert' then
     proc_lmslos_confirm(p_flag,p_pageval,p_parval1,p_parval2,p_parval3,p_OutMsg);
     open qry_result for
     select p_OutMsg from dual;*/


      elsif p_flag='getrequestedloan' or p_flag='getextemi' or p_flag='getextten' or p_flag='confirm_morotorium' or p_flag='confirmLoan' then
       proc_nloan_morotorium_request(p_flag,p_pageval,p_parval1,p_parval2,QRY_RESULT);

     elsif  p_flag='rdlcpredis' then
          proc_predis_rdlc_select(p_flag,p_pageval,p_parval1,p_parval2,p_parval3,qry_result);

     elsif p_flag='loanoverdue' then
        proc_overdue_collection(p_flag,p_pageval, p_parval1, p_parval2,QRY_RESULT );

    elsif  p_flag='pdc_ach_updation'  or p_flag='pdc_ach_updation_emidate' or  p_flag='loan_cleared_bounced_confirm' or p_flag='showdetailsapprove' or  p_flag='confirmapprove_pdcach' then
          proc_pdc_ach_updation_request(p_flag,p_pageval, p_parval1, p_parval2 , QRY_RESULT );

        elsif p_Flag='GETPDCREPORT' then
       proc_pdc_presentment_report(p_flag,p_pageval, p_parval1, p_parval2 , QRY_RESULT);
       
       elsif p_flag = 'OTHERVAL' then 
         proc_update_collateral(p_flag,p_pageval, p_parval1, p_parval2 , QRY_RESULT);
         
         elsif p_flag = 'punching_block_entry' then
           proc_add_punch_block(p_flag,p_pageval, p_parval1, p_parval2 , QRY_RESULT);
               
           elsif p_flag = 'block_details_select' then 
             proc_get_blocked_list(p_flag,p_pageval, p_parval1, p_parval2 , QRY_RESULT);
           
           elsif p_flag = 'unblock_details_punch' then 
             proc_unblock_punch (p_flag,p_pageval, p_parval1, p_parval2 , QRY_RESULT);
          
          elsif p_flag = 'Check_Post_details' then 
              proc_check_post(p_flag,p_pageval, p_parval1, p_parval2 , QRY_RESULT);
              
              elsif p_flag = 'Get_emp_details' then 
                proc_get_emp_details(p_flag,p_pageval, p_parval1, p_parval2 , QRY_RESULT);             
                                          
                elsif p_flag = 'punching_block_entry_mhf' then
                 proc_add_punch_block_mhf(p_flag,p_pageval, p_parval1, p_parval2 , QRY_RESULT);
                
            elsif p_flag = 'Check_Emp_code' then 
              proc_check_emp_code_mhf(p_flag,p_pageval, p_parval1, p_parval2 , QRY_RESULT);
              
                elsif p_flag = 'block_details_select_mhf' then 
             proc_get_blocked_list_mhf(p_flag,p_pageval, p_parval1, p_parval2 , QRY_RESULT);
             
              elsif p_flag = 'unblock_details_punch_mhf' then 
             proc_unblock_punch_mhf (p_flag,p_pageval, p_parval1, p_parval2 , QRY_RESULT);
             
              elsif p_flag = 'punching_block_entry_ms' then
                 proc_add_punch_block_ms(p_flag,p_pageval, p_parval1, p_parval2 , QRY_RESULT);
                 
                  elsif p_flag = 'block_details_select_ms' then 
             proc_get_blocked_list_ms(p_flag,p_pageval, p_parval1, p_parval2 , QRY_RESULT);
             
             elsif p_flag = 'unblock_details_punch_ms' then 
             proc_unblock_punch_ms (p_flag,p_pageval, p_parval1, p_parval2 , QRY_RESULT);
             
             
             
      elsif p_Flag='EMI_Change' then
       proc_EMI_Change_Date(p_pageval, p_parval1, p_parval2 , QRY_RESULT);
      elsif p_Flag='PDC_ACH_STATUS' then
         proc_nloan_pdc_ach_status(p_pageval, p_parval1, p_parval2, QRY_RESULT);
     elsif p_flag='PledgeBlock' then
         proc_nloan_lien_marking(p_pageval, p_parval1, p_parval2,p_parval3, QRY_RESULT);

        elsif p_Flag='GETLOANDETAIL' then
     proc_branch_insurance_data(p_pageval,p_parval1,p_parval2,QRY_RESULT);
          elsif p_Flag='GetRelationWithApplicant' then
     proc_get_relation(p_pageval,p_parval1,QRY_RESULT);
       elsif p_Flag='FillData' then
     proc_get_relation(p_pageval,p_parval1,QRY_RESULT);
      elsif p_Flag='INSURANCEREPORT' then
     proc_nloan_insurance_report(p_flag,p_pageval, p_parval1, p_parval2,p_parval3 , QRY_RESULT);
      elsif p_Flag = 'TWLoan' then 
        proc_TWLoan(p_flag,p_pageval, p_parval1, p_parval2,p_parval3 , QRY_RESULT);
    elsif p_Flag='PDC_PRESENTMENT' then
         proc_nloan_pdc_presentment(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);

   elsif p_Flag='LOANRESTUCTURE' then
         proc_nloan_loan_restructure(p_flag,p_pageval, p_parval1, p_parval2 ,p_parval3, QRY_RESULT);
          elsif p_Flag='GETSOA' then
         proc_nloan_statement_acct(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);
     elsif  p_flag='camrdlc' then
          proc_camrdlc_report(p_flag,p_pageval,p_parval1,p_parval2,p_parval3,qry_result);

   elsif  p_flag='app_details_entry' then
       proc_Applicant_details_entry(p_flag, p_pageval, p_parval1,p_parval2,p_parval3,QRY_RESULT);
     elsif p_Flag='LEADENTRY' then
         proc_nloan_confirm_lead(p_pageval, p_parval1, QRY_RESULT);

   elsif p_Flag='PDC_ACH_STATUS' then
         proc_nloan_pdc_ach_status(p_pageval, p_parval1, p_parval2, QRY_RESULT);

   elsif p_Flag='PERSONAL_DISCUSSION' then
         proc_nloan_personal_discussion(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);

  elsif p_Flag='CMPERSONALDISCUSSION' then
         proc_nloan_cmpd(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);

  elsif p_Flag='NEWAPPLICATION_RDLC' then
         proc_nloan_newapplication_rdlc(p_pageval, p_parval1, p_parval2, QRY_RESULT);

    elsif p_Flag='unfrontapproval' then
          proc_nloan_Unfrond_approval(p_pageval,p_parval1 ,p_parval2,p_parval3,QRY_RESULT);

  elsif p_Flag='LOANDISBURSEMENT' then
          proc_nloan_loan_disbursement(p_pageval,p_parval1 ,p_parval2,p_parval3,QRY_RESULT);

 /* elsif p_Flag='PAYMENTDATA' then
          proc_nloan_loan_payment(p_pageval,p_parval1 ,p_parval2,p_parval3,QRY_RESULT);*/

  elsif p_Flag='PD_CONFIRMATION' then
         proc_nloan_pd_confirmation(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);

    elsif p_Flag='CREDITAPPRAISAL' then
         PROC_NLOAN_CREDITAPPRAISAL(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);
 elsif p_Flag='empanelment_advocates' then
         proc_empanelment_advocates(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);
         
 elsif p_Flag='Death_Cust_Dtl' then
         proc_death_cust_dtl(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);        

   elsif  p_Flag='SUBACCOUNTSEL' then
       open QRY_RESULT for
         select t.acc_no, t.description from tbl_lms_status_master t where module_id = 7 and option_id = 1;

      elsif p_Flag='essagent' then
          proc_ess_agent_collection(p_pageval,p_parval1 ,p_parval2,p_parval3,QRY_RESULT);
  elsif p_Flag='NESL_REPORT' then
         proc_nloan_nesl_report(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);

  elsif p_Flag='NEWLOANAPPLICATION' then
       proc_new_application(p_pageval,p_parval1,p_parval2,p_parval3,QRY_RESULT);

 elsif p_flag='LeadBulkUpload' then
     proc_lmslos_confirm(p_flag,p_pageval,p_parval1,p_parval2,p_parval3,p_OutMsg);
     open qry_result for
     select p_OutMsg from dual;
     elsif p_Flag='DIGITAL_MARKKETING' then
         proc_lead_marketing(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);

  elsif p_Flag='LMSAUTOCPMPLETE' then   --autocomplete
      if p_pageVal='GetCustName' then
                      open QRY_RESULT for
           --  select t.account_no,T.account_name||'-'||t.ACCOUNT_NO from ACCOUNT_PROFILE t where t.ho_status=0 and t.account_name like '%'||UPPER(p_parval1)||'%';
          select t.cust_id, t.cust_id||'-'||t.cust_name from customer t where t.cust_name like ''||UPPER(p_parval1)||'%';
       elsif p_pageVal='GetBranchName' then
                      open QRY_RESULT for
                    select t.branch_id, t.branch_id||'-'||t.branch_name from branch_master t where t.status_id<>0 and t.branch_name like ''||UPPER(p_parval1)||'%' or t.branch_id like ''||UPPER(p_parval1)||'%' ;

       end if;

   elsif p_Flag='PropertyVisit' then
         proc_nloan_property_visit(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);
      elsif p_Flag='NESL_NON_REPORT' then --NESL Non Individual Report
         proc_nloan_nesl_non_report(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);
         
     elsif p_Flag='EMICALLREMINDER' then
         proc_emi_call_reminder(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);

    
  elsif p_Flag='InterestIncomeRpt' then
        proc_InterestIncomeRpt(p_pageval, p_parval1, p_parval2, p_parval3, qry_result);
    elsif p_Flag='TRANSFER' then
    proc_transfer_confirm(p_pageval, p_parval1, p_parval1, p_parval2,QRY_RESULT);
    elsif p_Flag='PAYU' then
        PROC_PLOAN_PAYU(p_flag,p_pageval, p_parval1,p_parval2,QRY_RESULT);
    ---- Sanoop
      elsif p_Flag='LOANFIXING' then
       proc_loan_fixing(p_pageval,p_parval1,p_parval2,p_parval3,QRY_RESULT);
     --sandeep
     elsif p_Flag='CUSTOMER_APPLICANT' then
      proc_customer_applicant(p_pageval,p_parval1,p_parval2,p_parval3,QRY_RESULT);


  elsif p_Flag='BULK_UPLOAD_NGL' then
      proc_bulkentry_upload_ngl(p_pageval,p_parval1,p_parval2,p_parval3,QRY_RESULT);


   elsif p_Flag='POST_DISBURESD_DOC' then
    proc_nloan_postdisb_note(p_pageval,p_parval1,p_parval2, p_parval3,QRY_RESULT);

     elsif p_Flag='LIEN_REPORT' then
         proc_nloan_lien_report(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);
-------- Riswana new change 11-may-2021
elsif p_flag='pdc_entry' then
     proc_lmslos_pdc_entry(p_flag,p_pageval,p_parval1,p_parval2,p_parval3,QRY_RESULT);
---------------
  elsif p_flag='CICUpload' then
     proc_lmslos_confirm(p_flag,p_pageval,p_parval1,p_parval2,p_parval3,p_OutMsg);
    open qry_result for
     select p_OutMsg from dual;
   ---- Krishna new one 14-may
    elsif p_Flag='RISK_CATEGORISATION' then
    PROC_NLOAN_RISK_CATEG_CUST(p_pageval,p_parval1,p_parval2, p_parval3,QRY_RESULT);

  elsif p_Flag='Predisbursement_data' then
    proc_nloan_pre_disbursement(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);
  ----jithi joy---
  elsif p_Flag='MHF_Rpt' then
        Proc_MHFReport(p_pageval, p_parval1, p_parval2, p_parval3, qry_result);

  --- sanoop change 1-may2021
    elsif p_Flag='DISBURSEMENT_REPORT' then
    proc_DisbursementReport(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);


   elsif p_Flag='CUSTOMERFEEDBACK' then
         proc_emi_customer_feedback(p_flag,p_pageval,p_parval1,p_parval2, p_parval3, QRY_RESULT);


   elsif p_Flag='FORECLOSURE' then
    proc_nloan_prepaymt(p_pageval,p_parval1,p_parval2, p_parval3,QRY_RESULT);
-----jithi change----
   elsif p_Flag='OEM_Rpt' then
        Proc_OEM_Report(p_pageval, p_parval1, p_parval2, p_parval3, qry_result);

   ----------------- Minnu K P
   elsif p_flag='TRANCHEDISBURSEMENT' then
     proc_nloan_tranchedisbursement(p_pageval,p_parval1 ,p_parval2,p_parval3,QRY_RESULT);
   ----------------- Risvana
   elsif p_Flag='Collection_Report' then

      proc_lmslos_collection_report(p_flag,p_pageval,p_parval1,p_parval2, p_parval3, QRY_RESULT);

   elsif p_Flag='DisbursementReport_Uptolastmonth' then

     proc_lmslos_DisbrseRprtlstmnth(p_flag,p_pageval,p_parval1,p_parval2, p_parval3, QRY_RESULT);

   elsif p_Flag='Consolidated_FileTrnsfrReprt' then

     proc_lmslos_Consolidt_FileTRpt(p_flag,p_pageval,p_parval1,p_parval2, p_parval3, QRY_RESULT);

   elsif p_Flag='BA_DSA_Rpt' then -----jithi change----
        Proc_BA_DSA_Rpt(p_pageval, p_parval1, p_parval2, p_parval3, qry_result);

   elsif p_flag='FILEHANDOVER' then   --- Minnu K P
     proc_nloan_filehandover(p_pageval,p_parval1 ,p_parval2,p_parval3,QRY_RESULT);

   elsif p_Flag='cust_Excelupload_noc' then
         Proc_send_noc(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);

   elsif p_Flag='LANGUAGEWISE' then    -----Sarath V P
       proc_crm_emi_call_reminder(p_pageval, p_parval1, p_parval2, p_parval3, qry_result);

   elsif p_Flag='EMIBIRTHDAYCALL' then   -----Sreeraj jayakumar
       proc_emi_crm_proc(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);

--------------------------Risvana--------
 elsif p_Flag='Delinquent_Collection' then
        proc_Delinquent_Colln_NGL(p_flag,p_pageval,p_parval1,p_parval2, p_parval3, QRY_RESULT);

 -------- Krishna
   elsif p_Flag='UPDATE_PROCESSING_FEE' then
    PROC_NLOAN_PROCESSING_FEE(p_pageval,p_parval1,p_parval2, p_parval3,QRY_RESULT);

    elsif p_flag='CustomerMapping' then
     proc_customer_mapping(p_pageval, p_parval1, p_parval2, QRY_RESULT);

----Jithi----
-- uncommented on 18-sep-2021 as disscussed with retheesh
   elsif p_Flag='BlockDtl' then
    proc_block_rpt(p_pageval,p_parval1,p_parval2, p_parval3,QRY_RESULT);

-------Ajil C G-------------CRM Released On : 01-10-2021, SR11470-------------
elsif p_Flag='RoLoanTransfer' then
NglCrm_RoLeaveTimeLoanTransfer(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);

 -- jus suit file upload for CRM module in LOS LMS-- Released On : 01-10-2021 -- Abijith v ----
  elsif p_Flag = 'UploadJusSuit' then
    proc_jusSuit_file(p_flag, p_pageval, p_parval1, p_parval2, p_parval3, p_OutMsg);
    open QRY_RESULT for
      select p_OutMsg from dual;
----------------------------------------------------Sreeraj (Credit Monitor Valuation Report)
   elsif p_Flag='CREDITMONITORASSIGN' then
     PROC_CREDITMONITOR(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);
elsif p_Flag='CREDIT_MONITORING' then
    proc_CreditMonitoring(p_flag,p_pageval, p_parval1, p_parval2,p_parval3 , QRY_RESULT);
elsif p_Flag='CM_Report' then
     PROC_CM_Report(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);

elsif p_Flag='advacateapprove'or p_flag='advacateapprovecnfm' or p_flag='advacateapprovereject' then
    proc_advacate_approval(p_flag,p_pageval, p_parval1, p_parval2, QRY_RESULT);
elsif p_Flag='ADVDTLS' then
         proc_nloan_Empanelment_Request(p_pageval,p_parval1,p_parval2, p_parval3,QRY_RESULT);

       elsif p_Flag='Legal_HP_customer_visit' then
         proc_legal_hp_customer_visit(p_pageval,p_parval1,p_parval2, p_parval3,QRY_RESULT);
     elsif p_Flag='CKValidation' then 
     proc_ckyc_Verification(p_pageval, p_parval1, p_parval2, QRY_RESULT);
     elsif  p_flag='GETHFINSURANCE' then
      proc_br_HomFin_insurance_data(p_pageval,p_parval1,p_parval2,QRY_RESULT);
         elsif  p_flag='GetDoc' then
        proc_insurance_doc(p_pageval,p_parval1,p_parval2,QRY_RESULT);
        
        
          elsif p_Flag='DemandNoticeExp' then
      proc_DemandLetterPrint(p_pageval, p_parval1, p_parval2, QRY_RESULT);
        
        

 elsif  p_flag='additionalDtl' then
        proc_crm_additional_dtl(p_pageval,p_parval1,p_parval2,QRY_RESULT);
   ---------------------------JIVIN AGENT COLECTION---------------------     
   elsif  p_flag='agency_cnfm'then
     proc_agency_confirm(p_pageval,p_parval1,QRY_RESULT);
    elsif  p_flag='agent_confirm'then
     proc_agency_confirm(p_pageval,p_parval1,QRY_RESULT);
      elsif  p_flag='agent_deposit'then
        proc_new_agent_app(p_pageval,p_parval1,error_status,error_message,QRY_RESULT);
        
        
   elsif p_flag='NGLLOANREPORT' then

        proc_ngl_loan_reports(p_pageval,p_parval1,p_parval2,p_parval3,QRY_RESULT); 

  elsif p_Flag='NGLCRMLEADENTRY' then
      proc_nglcrm_LeadEntry(p_pageval, p_parval1, p_parval2, QRY_RESULT);
     
     
 elsif  p_flag='complaint' then
        proc_crm_customer_complaint(p_pageval,p_parval1,p_parval2,QRY_RESULT);
        
  elsif  p_flag='SETRO' then
        proc_ro_adding(p_pageval,p_parval1,p_parval2,QRY_RESULT);
        
  /* elsif  p_flag='RemoveRo' then
        proc_roremoverequest(p_pageval,p_parval1,p_parval2,QRY_RESULT);   */
        
   elsif  p_flag='CUSTPROFILE' then
        proc_customer_profile_updt(p_pageval,p_parval1,p_parval2,QRY_RESULT);
        
  /*created by SANGEETHA KR 10/08/22*/      
         elsif  p_flag='MSMECUSTPROFILE' then
        proc_msme_customer_profile_updt(p_pageval,p_parval1,p_parval2,QRY_RESULT);
        
        
        
  elsif p_Flag='LEGALNOTICE' then
      proc_nloan_legalnotice(p_flag,p_pageval, p_parval1, p_parval2, QRY_RESULT); 
      
       elsif  p_flag='ROCallingModule' then
        proc_RMRoCallupdating(p_pageval,p_parval1,p_parval2,QRY_RESULT);  
        
         elsif  p_flag='panUpdation' then
        proc_pan_updation(p_pageval,p_parval1,p_parval2,QRY_RESULT);  
         elsif  p_flag='INCENTIVE' then
        proc_so_incentive(p_pageval,p_parval1,p_parval2,QRY_RESULT);
         
    elsif  p_flag='NACH_STATUS' then
        proc_nach_status_updation(p_pageval,p_parval1,p_parval2,QRY_RESULT); 
        
         elsif p_Flag='collectionofficersupdation' then
      proc_collectiondetailsupdation(p_pageval, p_parval1, p_parval2, QRY_RESULT);
   
  /*date:6-08-22 
  creadedby:sangeetha K R
  purpose:insurance amount automatic calculation*/
    
      elsif p_Flag='INSURANCEDISB' then
     proc_insurance_disb(p_pageval, p_parval1, p_parval2, QRY_RESULT);
     
     
      elsif p_Flag='INSURANCEDISB_SPL' then
     proc_insurance_disb_spl(p_pageval, p_parval1, p_parval2, QRY_RESULT);
     
    
     
 /*elsif p_Flag='STUDREG' then
     proc_stud_registration(p_pageval, p_parval1, p_parval2, QRY_RESULT);*/
     
    /* created by Anu*/ 
     elsif p_Flag='TRANSREPORT' then
     proc_loan_transaction_report(p_pageval, p_parval1, p_parval2, QRY_RESULT);
     
     elsif p_Flag='NOMINEEDETAILS' then
     proc_nominee_details(p_pageval, p_parval1, p_parval2, QRY_RESULT);
     
    elsif p_Flag='nomineechecker' then
     proc_nominee_details(p_pageval, p_parval1, p_parval2, QRY_RESULT);
       
   /*elsif p_Flag='bulkemi_approval' then
     proc_bulkemiapproval(p_pageval, p_parval1, p_parval2, QRY_RESULT);*/
     
     elsif p_flag='BulkEmiCollection' then
     proc_bulkemi(p_flag,p_pageval,p_parval1,p_parval2,p_parval3,p_OutMsg);
     open qry_result for
     select p_OutMsg from dual;
    
    elsif p_flag='BulkAdvance' then
     proc_bulkadv(p_flag,p_pageval,p_parval1,p_parval2,p_parval3,p_OutMsg);
     open qry_result for
     select p_OutMsg from dual;
     
      elsif  p_flag='BulkAdvance_Approval' then
        proc_bulkadv_approval(p_pageval,p_parval1,p_parval2,QRY_RESULT); 
        
    elsif p_Flag='khatouni_kharsa_documentupload' then
       proc_khatouni(p_pageval,p_parval1, p_parval2,QRY_RESULT);
       
       
   elsif p_Flag='DOCUMENTVERIFY_MSME' then 
     proc_NloanDocumentVerifymsme(p_pageval, p_parval1, p_parval2, QRY_RESULT);  
       
      
       
     
     -----------
    elsif p_Flag='rbismareport' then
     proc_smaclassification(p_pageval, p_parval1, p_parval2, QRY_RESULT);  
     
      elsif p_Flag='DOCUMENTVERIFY' then --------Document verify SPL-------Anjusha-------------
     proc_NloanDocumentVerify(p_pageval, p_parval1, p_parval2, QRY_RESULT);  
     
       /*date:29-08-22 , creadedby:Risvana */
    elsif p_Flag='FileVerificationReport' then
     proc_FileVerificationReport(p_flag,p_pageval, p_parval1, p_parval2,p_parval3, QRY_RESULT); 
     
       elsif p_Flag='CRM_MSME' then
       PROC_DEPT_EMI_CALL_REMINDER(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);
       elsif p_Flag='CRM_SPL' then
       PROC_SPL_EMI_CALL_REMINDER(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);
----------
elsif p_Flag='DeptRoLoanTransfer' then
proc_dept_RoLeaveTimeLoanTransfer(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);

   
  elsif p_flag='DPL_excelupload' then
     proc_lmslos_confirm(p_flag,p_pageval,p_parval1,p_parval2,p_parval3,p_OutMsg);
     open qry_result for
     select p_OutMsg from dual;
     
    elsif p_flag='DPL_CHECK_ACCESS' then
     proc_dpl_checkaccess(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);
     
/*created by veena  */      
       elsif  p_flag='CUSTMRPROFILESPL' then
        proc_customer_profile_updation_spl(p_pageval,p_parval1,p_parval2,QRY_RESULT);    
 
  /*date:6-10-22 
  createdby:sangeetha K R
  purpose:LG_LC_STATUS*/
    
  
     elsif p_Flag='LG_LC_STATUS' then
     proc_lg_lc_status(p_pageval, p_parval1, p_parval2, QRY_RESULT);
     
    elsif p_Flag='TransactionDetails' then
     proc_transaction_details(p_pageval, p_parval1, p_parval2, QRY_RESULT);

  elsif p_Flag='DOCRETURN' then  
      proc_nloan_document_return(p_pageval, p_parval1, p_parval2, QRY_RESULT);
      
       elsif p_Flag='MNTHENDRBIREPORT' then --------Monthend RBI Report-------Anjusha-------------
     proc_MonthEndRBIReport(p_pageval, p_parval1, p_parval2, QRY_RESULT);
     
     elsif p_Flag='Smanewreport' then 
      proc_sma_latest_reports(p_pageval, p_parval1, p_parval2, QRY_RESULT);
 
 elsif p_Flag='VALUERDETAILS' then 
      proc_valuer_details(p_pageval, p_parval1, p_parval2, QRY_RESULT);

 elsif p_Flag='SPLDOCUMENTVERIFY' then --------Document verify SPL(operations)-------veena-------------
     spl_proc_NloanDocumentVerify(p_pageval, p_parval1, p_parval2, QRY_RESULT); 
  
    
 elsif p_Flag='MSMEDOCUMENTVERIFY' then --------Document verify MSME(operations)-------NAVARAG-------------
     msme_proc_NloanDocumentVerify(p_pageval, p_parval1, p_parval2, QRY_RESULT); 
 
     
  elsif p_Flag='rdlctest' then
     PROC_DUMMY_PROCEDURE(p_pageval, p_parval1, p_parval2, QRY_RESULT); 
     
    
     
      elsif p_Flag='MHF_BRANCH_INVENTORY_REPORT' then
    proc_Branch_inventory_report_MHF(p_flag,p_pageval, p_parval1, p_parval2,p_parval3 , QRY_RESULT);
    
           -------------------Deliquency___Report--------------------
    elsif  p_flag='DELIQUENCY_REPORT' then
           proc_deliquency_report(p_pageval,p_parval1,p_parval2,QRY_RESULT);
           
           -----shifting files from branch to agency---------
          elsif  p_flag='SHIFTING_FILES' then
           proc_shifting_files(p_pageVal,p_parval1,p_parval2,p_parval3,QRY_RESULT); 
           
           
      -----Returning files from branch to agency---------
      
          elsif  p_flag='RETURN_FILES' then
           proc_return_files(p_pageVal,p_parval1,p_parval2,p_parval3,QRY_RESULT); 
        
        
     elsif  p_Flag='NOC_CERTIFICATE'  then
     proc_nloan_noc_certificate(p_pageVal,p_parval1,p_parval2,p_parval3,QRY_RESULT);  
     
       elsif p_Flag='STATEMENTOFACCOUNTSCRM' then
      proc_NGLCRM_LOANSTATEMENT(p_pageval, p_parval1, p_parval2, QRY_RESULT);
   /*   
   elsif p_Flag='msme_pdc_entry' then
    proc_lmslos_msme_pdc_entry(p_pageval,p_parval1,p_parval3,QRY_RESULT);
   */ 
    
     elsif p_Flag='msme_pdc_entry' then
    proc_lmslos_msme_pdc_entry(p_flag,p_pageval,p_parval1,p_parval2,p_parval3,QRY_RESULT);

        
       
        elsif p_Flag='INSU_CUST_UPD' then
       Proc_ins_cust_updation(p_pageval,p_parval1,p_parval2,p_parval3,QRY_RESULT); 

     elsif p_Flag='AUTOGENERATION' then
         proc_AutoGeneration(p_pageval,p_parval1,p_parval2,QRY_RESULT);
         
         
        elsif p_Flag='INS_GET_DATA' then
     proc_ins_person_detail(p_pageval, p_parval1, p_parval2, QRY_RESULT);
     
          elsif p_Flag='DOCUMENTPRINT' then
     proc_document_print_new(p_pageval,p_parval1,p_parval2,QRY_RESULT);
     
     /* spl dunning_letter*/
     elsif p_Flag='DUNNINGLETTER' then
     proc_SplDUNNINGLETTER(p_pageval,p_parval1,p_parval2,QRY_RESULT); 
     
       elsif p_Flag='RevLetter' then
         proc_revivalLetter(p_pageval,p_parval1,p_parval2,QRY_RESULT); 
         
          elsif p_Flag='ReviewOfVerticalLoans' then
         proc_Riview_Of_Vertical_Loans(p_pageval,p_parval1,p_parval2,QRY_RESULT);
         
         elsif p_Flag='GETLEADREPORT' then--SPL MIS LEAD REPORT
         spl_proc_GETLEADREPORT(p_pageval,p_parval1,p_parval2,QRY_RESULT);
         
         elsif p_Flag='Riskcatreport' then
         pROC_RISKCATEGORISATION_RPT(p_pageval,p_parval1,p_parval2,QRY_RESULT);
         
         elsif p_Flag='dpdcollections' then
     proc_dpdcollections(p_pageval, p_parval1, p_parval2, p_parval3, QRY_RESULT);
     
     elsif p_Flag='Credit_File_Report' then
         proc_credit_file_report(p_pageval,p_parval1,p_parval2,QRY_RESULT);
         
         elsif p_Flag='operation_file_report' then
         proc_operation_file_report(p_pageval,p_parval1,p_parval2,QRY_RESULT);
        
        /* elsif p_flag='CallUpdation' then 
         proc_call_updation(p_flag,p_pageval,p_parval1,p_parval2,p_parval3,QRY_RESULT);
         */
         
          elsif p_flag='legal_assign_work' then 
         pro_nloan_leagal_work_assign_select(p_pageval,p_parval1,p_parval2,QRY_RESULT);


                   /* -----MAHEESH----- */  
/*
     elsif p_Flag='settilment_type' then
         proc_lms_settilment(p_pageval,p_parval1,p_parval2,QRY_RESULT);
     */
     /*//////// IMPORTANT NOTE FOR ALL EMPLOYEES USING THIS PROCEDURE////////////////
     ///////////////////---When reload alert comes Kindly click yes for new changes--- ////////*/
  
 end if;

end proc_lmslos_select;
