using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel;
using System.Text;
using System.Threading.Tasks;
using ERP.GetTTGateWay;

namespace ERP
{
    public class CallERPIntercace : GetTTGateWay.TIPTOPServiceGateWayPortType
    {
        //GetTTGateWay
        [return: MessageParameter(Name = "response")]
        public string callbackSrv(string request)
        {
            throw new NotImplementedException();
        }

        [return: MessageParameter(Name = "response")]
        public Task<string> callbackSrvAsync(string request)
        {
            throw new NotImplementedException();
        }

        public CheckApsExecutionResponse CheckApsExecution(CheckApsExecutionRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CheckApsExecutionResponse> CheckApsExecutionAsync(CheckApsExecutionRequest request)
        {
            throw new NotImplementedException();
        }

        public CheckExecAuthorizationResponse CheckExecAuthorization(CheckExecAuthorizationRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CheckExecAuthorizationResponse> CheckExecAuthorizationAsync(CheckExecAuthorizationRequest request)
        {
            throw new NotImplementedException();
        }

        public CheckUserAuthResponse CheckUserAuth(CheckUserAuthRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CheckUserAuthResponse> CheckUserAuthAsync(CheckUserAuthRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateAddressDataResponse CreateAddressData(CreateAddressDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateAddressDataResponse> CreateAddressDataAsync(CreateAddressDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateBillingAPResponse CreateBillingAP(CreateBillingAPRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateBillingAPResponse> CreateBillingAPAsync(CreateBillingAPRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateBOMDataResponse CreateBOMData(CreateBOMDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateBOMDataResponse> CreateBOMDataAsync(CreateBOMDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateBOMDetailDataResponse CreateBOMDetailData(CreateBOMDetailDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateBOMDetailDataResponse> CreateBOMDetailDataAsync(CreateBOMDetailDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateBOMMasterDataResponse CreateBOMMasterData(CreateBOMMasterDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateBOMMasterDataResponse> CreateBOMMasterDataAsync(CreateBOMMasterDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateCustomerContactDataResponse CreateCustomerContactData(CreateCustomerContactDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateCustomerContactDataResponse> CreateCustomerContactDataAsync(CreateCustomerContactDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateCustomerDataResponse CreateCustomerData(CreateCustomerDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateCustomerDataResponse> CreateCustomerDataAsync(CreateCustomerDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateCustomerOtheraddressDataResponse CreateCustomerOtheraddressData(CreateCustomerOtheraddressDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateCustomerOtheraddressDataResponse> CreateCustomerOtheraddressDataAsync(CreateCustomerOtheraddressDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateDepartmentDataResponse CreateDepartmentData(CreateDepartmentDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateDepartmentDataResponse> CreateDepartmentDataAsync(CreateDepartmentDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateECNDataResponse CreateECNData(CreateECNDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateECNDataResponse> CreateECNDataAsync(CreateECNDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateEmployeeDataResponse CreateEmployeeData(CreateEmployeeDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateEmployeeDataResponse> CreateEmployeeDataAsync(CreateEmployeeDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateIssueReturnDataResponse CreateIssueReturnData(CreateIssueReturnDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateIssueReturnDataResponse> CreateIssueReturnDataAsync(CreateIssueReturnDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateItemApprovalDataResponse CreateItemApprovalData(CreateItemApprovalDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateItemApprovalDataResponse> CreateItemApprovalDataAsync(CreateItemApprovalDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateItemMasterDataResponse CreateItemMasterData(CreateItemMasterDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateItemMasterDataResponse> CreateItemMasterDataAsync(CreateItemMasterDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateMISCIssueDataResponse CreateMISCIssueData(CreateMISCIssueDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateMISCIssueDataResponse> CreateMISCIssueDataAsync(CreateMISCIssueDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreatePLMBOMDataResponse CreatePLMBOMData(CreatePLMBOMDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreatePLMBOMDataResponse> CreatePLMBOMDataAsync(CreatePLMBOMDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreatePOReceivingDataResponse CreatePOReceivingData(CreatePOReceivingDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreatePOReceivingDataResponse> CreatePOReceivingDataAsync(CreatePOReceivingDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreatePotentialCustomerDataResponse CreatePotentialCustomerData(CreatePotentialCustomerDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreatePotentialCustomerDataResponse> CreatePotentialCustomerDataAsync(CreatePotentialCustomerDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreatePurchaseStockInResponse CreatePurchaseStockIn(CreatePurchaseStockInRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreatePurchaseStockInResponse> CreatePurchaseStockInAsync(CreatePurchaseStockInRequest request)
        {
            throw new NotImplementedException();
        }

        public CreatePurchaseStockOutResponse CreatePurchaseStockOut(CreatePurchaseStockOutRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreatePurchaseStockOutResponse> CreatePurchaseStockOutAsync(CreatePurchaseStockOutRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateQuotationDataResponse CreateQuotationData(CreateQuotationDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateQuotationDataResponse> CreateQuotationDataAsync(CreateQuotationDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateRepSubPBOMDataResponse CreateRepSubPBOMData(CreateRepSubPBOMDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateRepSubPBOMDataResponse> CreateRepSubPBOMDataAsync(CreateRepSubPBOMDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateShippingOrderResponse CreateShippingOrder(CreateShippingOrderRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateShippingOrderResponse> CreateShippingOrderAsync(CreateShippingOrderRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateShippingOrdersWithoutOrdersResponse CreateShippingOrdersWithoutOrders(CreateShippingOrdersWithoutOrdersRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateShippingOrdersWithoutOrdersResponse> CreateShippingOrdersWithoutOrdersAsync(CreateShippingOrdersWithoutOrdersRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateStockDataResponse CreateStockData(CreateStockDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateStockDataResponse> CreateStockDataAsync(CreateStockDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateStockInDataResponse CreateStockInData(CreateStockInDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateStockInDataResponse> CreateStockInDataAsync(CreateStockInDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateSupplierItemDataResponse CreateSupplierItemData(CreateSupplierItemDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateSupplierItemDataResponse> CreateSupplierItemDataAsync(CreateSupplierItemDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateTransferNoteResponse CreateTransferNote(CreateTransferNoteRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateTransferNoteResponse> CreateTransferNoteAsync(CreateTransferNoteRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateVendorDataResponse CreateVendorData(CreateVendorDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateVendorDataResponse> CreateVendorDataAsync(CreateVendorDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateVoucherDataResponse CreateVoucherData(CreateVoucherDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateVoucherDataResponse> CreateVoucherDataAsync(CreateVoucherDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateWOStockinDataResponse CreateWOStockinData(CreateWOStockinDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateWOStockinDataResponse> CreateWOStockinDataAsync(CreateWOStockinDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CreateWOWorkReportDataResponse CreateWOWorkReportData(CreateWOWorkReportDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CreateWOWorkReportDataResponse> CreateWOWorkReportDataAsync(CreateWOWorkReportDataRequest request)
        {
            throw new NotImplementedException();
        }

        public CRMGetCustomerDataResponse CRMGetCustomerData(CRMGetCustomerDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<CRMGetCustomerDataResponse> CRMGetCustomerDataAsync(CRMGetCustomerDataRequest request)
        {
            throw new NotImplementedException();
        }

        public EboGetCustDataResponse EboGetCustData(EboGetCustDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<EboGetCustDataResponse> EboGetCustDataAsync(EboGetCustDataRequest request)
        {
            throw new NotImplementedException();
        }

        public EboGetOrderDataResponse EboGetOrderData(EboGetOrderDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<EboGetOrderDataResponse> EboGetOrderDataAsync(EboGetOrderDataRequest request)
        {
            throw new NotImplementedException();
        }

        public EboGetProdDataResponse EboGetProdData(EboGetProdDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<EboGetProdDataResponse> EboGetProdDataAsync(EboGetProdDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetAccountDataResponse GetAccountData(GetAccountDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetAccountDataResponse> GetAccountDataAsync(GetAccountDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetAccountSubjectDataResponse GetAccountSubjectData(GetAccountSubjectDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetAccountSubjectDataResponse> GetAccountSubjectDataAsync(GetAccountSubjectDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetAccountTypeDataResponse GetAccountTypeData(GetAccountTypeDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetAccountTypeDataResponse> GetAccountTypeDataAsync(GetAccountTypeDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetAreaDataResponse GetAreaData(GetAreaDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetAreaDataResponse> GetAreaDataAsync(GetAreaDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetAreaListResponse GetAreaList(GetAreaListRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetAreaListResponse> GetAreaListAsync(GetAreaListRequest request)
        {
            throw new NotImplementedException();
        }

        public GetAxmDocumentResponse GetAxmDocument(GetAxmDocumentRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetAxmDocumentResponse> GetAxmDocumentAsync(GetAxmDocumentRequest request)
        {
            throw new NotImplementedException();
        }

        public GetBasicCodeDataResponse GetBasicCodeData(GetBasicCodeDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetBasicCodeDataResponse> GetBasicCodeDataAsync(GetBasicCodeDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetBOMDataResponse GetBOMData(GetBOMDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetBOMDataResponse> GetBOMDataAsync(GetBOMDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetBrandDataResponse GetBrandData(GetBrandDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetBrandDataResponse> GetBrandDataAsync(GetBrandDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetCardDetailDataResponse GetCardDetailData(GetCardDetailDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetCardDetailDataResponse> GetCardDetailDataAsync(GetCardDetailDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetComponentrepsubDataResponse GetComponentrepsubData(GetComponentrepsubDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetComponentrepsubDataResponse> GetComponentrepsubDataAsync(GetComponentrepsubDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetCostGroupDataResponse GetCostGroupData(GetCostGroupDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetCostGroupDataResponse> GetCostGroupDataAsync(GetCostGroupDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetCountingLabelDataResponse GetCountingLabelData(GetCountingLabelDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetCountingLabelDataResponse> GetCountingLabelDataAsync(GetCountingLabelDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetCountryDataResponse GetCountryData(GetCountryDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetCountryDataResponse> GetCountryDataAsync(GetCountryDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetCountryListResponse GetCountryList(GetCountryListRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetCountryListResponse> GetCountryListAsync(GetCountryListRequest request)
        {
            throw new NotImplementedException();
        }

        public GetCouponDataResponse GetCouponData(GetCouponDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetCouponDataResponse> GetCouponDataAsync(GetCouponDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetCurrencyDataResponse GetCurrencyData(GetCurrencyDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetCurrencyDataResponse> GetCurrencyDataAsync(GetCurrencyDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetCurrencyListResponse GetCurrencyList(GetCurrencyListRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetCurrencyListResponse> GetCurrencyListAsync(GetCurrencyListRequest request)
        {
            throw new NotImplementedException();
        }

        public GetCustClassificationDataResponse GetCustClassificationData(GetCustClassificationDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetCustClassificationDataResponse> GetCustClassificationDataAsync(GetCustClassificationDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetCustListResponse GetCustList(GetCustListRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetCustListResponse> GetCustListAsync(GetCustListRequest request)
        {
            throw new NotImplementedException();
        }

        public GetCustomerAccAmtDataResponse GetCustomerAccAmtData(GetCustomerAccAmtDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetCustomerAccAmtDataResponse> GetCustomerAccAmtDataAsync(GetCustomerAccAmtDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetCustomerContactDataResponse GetCustomerContactData(GetCustomerContactDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetCustomerContactDataResponse> GetCustomerContactDataAsync(GetCustomerContactDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetCustomerDataResponse GetCustomerData(GetCustomerDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetCustomerDataResponse> GetCustomerDataAsync(GetCustomerDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetCustomerOtheraddressDataResponse GetCustomerOtheraddressData(GetCustomerOtheraddressDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetCustomerOtheraddressDataResponse> GetCustomerOtheraddressDataAsync(GetCustomerOtheraddressDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetCustomerProductDataResponse GetCustomerProductData(GetCustomerProductDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetCustomerProductDataResponse> GetCustomerProductDataAsync(GetCustomerProductDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetDataCountResponse GetDataCount(GetDataCountRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetDataCountResponse> GetDataCountAsync(GetDataCountRequest request)
        {
            throw new NotImplementedException();
        }

        public GetDepartmentDataResponse GetDepartmentData(GetDepartmentDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetDepartmentDataResponse> GetDepartmentDataAsync(GetDepartmentDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetDepartmentListResponse GetDepartmentList(GetDepartmentListRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetDepartmentListResponse> GetDepartmentListAsync(GetDepartmentListRequest request)
        {
            throw new NotImplementedException();
        }

        public GetDocumentNumberResponse GetDocumentNumber(GetDocumentNumberRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetDocumentNumberResponse> GetDocumentNumberAsync(GetDocumentNumberRequest request)
        {
            throw new NotImplementedException();
        }

        public GetEmployeeDataResponse GetEmployeeData(GetEmployeeDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetEmployeeDataResponse> GetEmployeeDataAsync(GetEmployeeDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetEmployeeListResponse GetEmployeeList(GetEmployeeListRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetEmployeeListResponse> GetEmployeeListAsync(GetEmployeeListRequest request)
        {
            throw new NotImplementedException();
        }

        public GetFQCDataResponse GetFQCData(GetFQCDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetFQCDataResponse> GetFQCDataAsync(GetFQCDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetInspectionDataResponse GetInspectionData(GetInspectionDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetInspectionDataResponse> GetInspectionDataAsync(GetInspectionDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetInvoiceTypeListResponse GetInvoiceTypeList(GetInvoiceTypeListRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetInvoiceTypeListResponse> GetInvoiceTypeListAsync(GetInvoiceTypeListRequest request)
        {
            throw new NotImplementedException();
        }

        public GetItemDataResponse GetItemData(GetItemDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetItemDataResponse> GetItemDataAsync(GetItemDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetItemGroupDataResponse GetItemGroupData(GetItemGroupDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetItemGroupDataResponse> GetItemGroupDataAsync(GetItemGroupDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetItemListResponse GetItemList(GetItemListRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetItemListResponse> GetItemListAsync(GetItemListRequest request)
        {
            throw new NotImplementedException();
        }

        public GetItemOtherGroupDataResponse GetItemOtherGroupData(GetItemOtherGroupDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetItemOtherGroupDataResponse> GetItemOtherGroupDataAsync(GetItemOtherGroupDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetItemStockListResponse GetItemStockList(GetItemStockListRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetItemStockListResponse> GetItemStockListAsync(GetItemStockListRequest request)
        {
            throw new NotImplementedException();
        }

        public GetLabelTypeDataResponse GetLabelTypeData(GetLabelTypeDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetLabelTypeDataResponse> GetLabelTypeDataAsync(GetLabelTypeDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetLocationDataResponse GetLocationData(GetLocationDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetLocationDataResponse> GetLocationDataAsync(GetLocationDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetMachineDataResponse GetMachineData(GetMachineDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetMachineDataResponse> GetMachineDataAsync(GetMachineDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetMemberCardDataResponse GetMemberCardData(GetMemberCardDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetMemberCardDataResponse> GetMemberCardDataAsync(GetMemberCardDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetMemberDataResponse GetMemberData(GetMemberDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetMemberDataResponse> GetMemberDataAsync(GetMemberDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetMenuDataResponse GetMenuData(GetMenuDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetMenuDataResponse> GetMenuDataAsync(GetMenuDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetMFGDocumentResponse GetMFGDocument(GetMFGDocumentRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetMFGDocumentResponse> GetMFGDocumentAsync(GetMFGDocumentRequest request)
        {
            throw new NotImplementedException();
        }

        public GetMFGSettingSmaDataResponse GetMFGSettingSmaData(GetMFGSettingSmaDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetMFGSettingSmaDataResponse> GetMFGSettingSmaDataAsync(GetMFGSettingSmaDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetMonthListResponse GetMonthList(GetMonthListRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetMonthListResponse> GetMonthListAsync(GetMonthListRequest request)
        {
            throw new NotImplementedException();
        }

        public GetOnlineUserResponse GetOnlineUser(GetOnlineUserRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetOnlineUserResponse> GetOnlineUserAsync(GetOnlineUserRequest request)
        {
            throw new NotImplementedException();
        }

        public GetOrganizationListResponse GetOrganizationList(GetOrganizationListRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetOrganizationListResponse> GetOrganizationListAsync(GetOrganizationListRequest request)
        {
            throw new NotImplementedException();
        }

        public GetOverdueAmtDetailDataResponse GetOverdueAmtDetailData(GetOverdueAmtDetailDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetOverdueAmtDetailDataResponse> GetOverdueAmtDetailDataAsync(GetOverdueAmtDetailDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetOverdueAmtRankingDataResponse GetOverdueAmtRankingData(GetOverdueAmtRankingDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetOverdueAmtRankingDataResponse> GetOverdueAmtRankingDataAsync(GetOverdueAmtRankingDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetPackingMethodDataResponse GetPackingMethodData(GetPackingMethodDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetPackingMethodDataResponse> GetPackingMethodDataAsync(GetPackingMethodDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetPaymentTermsDataResponse GetPaymentTermsData(GetPaymentTermsDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetPaymentTermsDataResponse> GetPaymentTermsDataAsync(GetPaymentTermsDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetPODataResponse GetPOData(GetPODataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetPODataResponse> GetPODataAsync(GetPODataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetPOReceivingInDataResponse GetPOReceivingInData(GetPOReceivingInDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetPOReceivingInDataResponse> GetPOReceivingInDataAsync(GetPOReceivingInDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetPOReceivingOutDataResponse GetPOReceivingOutData(GetPOReceivingOutDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetPOReceivingOutDataResponse> GetPOReceivingOutDataAsync(GetPOReceivingOutDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetPotentialCustomerDataResponse GetPotentialCustomerData(GetPotentialCustomerDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetPotentialCustomerDataResponse> GetPotentialCustomerDataAsync(GetPotentialCustomerDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetProdClassListResponse GetProdClassList(GetProdClassListRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetProdClassListResponse> GetProdClassListAsync(GetProdClassListRequest request)
        {
            throw new NotImplementedException();
        }

        public GetProdInfoResponse GetProdInfo(GetProdInfoRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetProdInfoResponse> GetProdInfoAsync(GetProdInfoRequest request)
        {
            throw new NotImplementedException();
        }

        public GetProdRoutingDataResponse GetProdRoutingData(GetProdRoutingDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetProdRoutingDataResponse> GetProdRoutingDataAsync(GetProdRoutingDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetProdStateResponse GetProdState(GetProdStateRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetProdStateResponse> GetProdStateAsync(GetProdStateRequest request)
        {
            throw new NotImplementedException();
        }

        public GetProductClassDataResponse GetProductClassData(GetProductClassDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetProductClassDataResponse> GetProductClassDataAsync(GetProductClassDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetPurchaseStockInQtyResponse GetPurchaseStockInQty(GetPurchaseStockInQtyRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetPurchaseStockInQtyResponse> GetPurchaseStockInQtyAsync(GetPurchaseStockInQtyRequest request)
        {
            throw new NotImplementedException();
        }

        public GetPurchaseStockOutQtyResponse GetPurchaseStockOutQty(GetPurchaseStockOutQtyRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetPurchaseStockOutQtyResponse> GetPurchaseStockOutQtyAsync(GetPurchaseStockOutQtyRequest request)
        {
            throw new NotImplementedException();
        }

        public GetQtyConversionResponse GetQtyConversion(GetQtyConversionRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetQtyConversionResponse> GetQtyConversionAsync(GetQtyConversionRequest request)
        {
            throw new NotImplementedException();
        }

        public GetQuotationDataResponse GetQuotationData(GetQuotationDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetQuotationDataResponse> GetQuotationDataAsync(GetQuotationDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetReasonCodeResponse GetReasonCode(GetReasonCodeRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetReasonCodeResponse> GetReasonCodeAsync(GetReasonCodeRequest request)
        {
            throw new NotImplementedException();
        }

        public GetReceivingQtyResponse GetReceivingQty(GetReceivingQtyRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetReceivingQtyResponse> GetReceivingQtyAsync(GetReceivingQtyRequest request)
        {
            throw new NotImplementedException();
        }

        public GetReportDataResponse GetReportData(GetReportDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetReportDataResponse> GetReportDataAsync(GetReportDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetSalesDetailDataResponse GetSalesDetailData(GetSalesDetailDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetSalesDetailDataResponse> GetSalesDetailDataAsync(GetSalesDetailDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetSalesDocumentResponse GetSalesDocument(GetSalesDocumentRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetSalesDocumentResponse> GetSalesDocumentAsync(GetSalesDocumentRequest request)
        {
            throw new NotImplementedException();
        }

        public GetSalesStatisticsDataResponse GetSalesStatisticsData(GetSalesStatisticsDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetSalesStatisticsDataResponse> GetSalesStatisticsDataAsync(GetSalesStatisticsDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetShappingDataResponse GetShappingData(GetShappingDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetShappingDataResponse> GetShappingDataAsync(GetShappingDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetShippingNoticeDataResponse GetShippingNoticeData(GetShippingNoticeDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetShippingNoticeDataResponse> GetShippingNoticeDataAsync(GetShippingNoticeDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetShippingOrderDataResponse GetShippingOrderData(GetShippingOrderDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetShippingOrderDataResponse> GetShippingOrderDataAsync(GetShippingOrderDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetSODataResponse GetSOData(GetSODataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetSODataResponse> GetSODataAsync(GetSODataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetSOInfoDataResponse GetSOInfoData(GetSOInfoDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetSOInfoDataResponse> GetSOInfoDataAsync(GetSOInfoDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetSOInfoDetailDataResponse GetSOInfoDetailData(GetSOInfoDetailDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetSOInfoDetailDataResponse> GetSOInfoDetailDataAsync(GetSOInfoDetailDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetSSOKeyResponse GetSSOKey(GetSSOKeyRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetSSOKeyResponse> GetSSOKeyAsync(GetSSOKeyRequest request)
        {
            throw new NotImplementedException();
        }

        public GetStockDataResponse GetStockData(GetStockDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetStockDataResponse> GetStockDataAsync(GetStockDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetSupplierDataResponse GetSupplierData(GetSupplierDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetSupplierDataResponse> GetSupplierDataAsync(GetSupplierDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetSupplierItemDataResponse GetSupplierItemData(GetSupplierItemDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetSupplierItemDataResponse> GetSupplierItemDataAsync(GetSupplierItemDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetTableAmendmentDataResponse GetTableAmendmentData(GetTableAmendmentDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetTableAmendmentDataResponse> GetTableAmendmentDataAsync(GetTableAmendmentDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetTaxTypeDataResponse GetTaxTypeData(GetTaxTypeDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetTaxTypeDataResponse> GetTaxTypeDataAsync(GetTaxTypeDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetTradeTermDataResponse GetTradeTermData(GetTradeTermDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetTradeTermDataResponse> GetTradeTermDataAsync(GetTradeTermDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetTransactionCategoryResponse GetTransactionCategory(GetTransactionCategoryRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetTransactionCategoryResponse> GetTransactionCategoryAsync(GetTransactionCategoryRequest request)
        {
            throw new NotImplementedException();
        }

        public GetUnitConversionDataResponse GetUnitConversionData(GetUnitConversionDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetUnitConversionDataResponse> GetUnitConversionDataAsync(GetUnitConversionDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetUnitDataResponse GetUnitData(GetUnitDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetUnitDataResponse> GetUnitDataAsync(GetUnitDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetUserDefOrgResponse GetUserDefOrg(GetUserDefOrgRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetUserDefOrgResponse> GetUserDefOrgAsync(GetUserDefOrgRequest request)
        {
            throw new NotImplementedException();
        }

        public GetUserTokenResponse GetUserToken(GetUserTokenRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetUserTokenResponse> GetUserTokenAsync(GetUserTokenRequest request)
        {
            throw new NotImplementedException();
        }

        public GetVoucherDocumentDataResponse GetVoucherDocumentData(GetVoucherDocumentDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetVoucherDocumentDataResponse> GetVoucherDocumentDataAsync(GetVoucherDocumentDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetWarehouseDataResponse GetWarehouseData(GetWarehouseDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetWarehouseDataResponse> GetWarehouseDataAsync(GetWarehouseDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetWODataResponse GetWOData(GetWODataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetWODataResponse> GetWODataAsync(GetWODataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetWOIssueDataResponse GetWOIssueData(GetWOIssueDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetWOIssueDataResponse> GetWOIssueDataAsync(GetWOIssueDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetWorkstationDataResponse GetWorkstationData(GetWorkstationDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetWorkstationDataResponse> GetWorkstationDataAsync(GetWorkstationDataRequest request)
        {
            throw new NotImplementedException();
        }

        public GetWOStockQtyResponse GetWOStockQty(GetWOStockQtyRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<GetWOStockQtyResponse> GetWOStockQtyAsync(GetWOStockQtyRequest request)
        {
            throw new NotImplementedException();
        }

        [return: MessageParameter(Name = "response")]
        public string invokeMdm(string request)
        {
            throw new NotImplementedException();
        }

        [return: MessageParameter(Name = "response")]
        public Task<string> invokeMdmAsync(string request)
        {
            throw new NotImplementedException();
        }

        [return: MessageParameter(Name = "response")]
        public string invokeSrv(string request)
        {
            throw new NotImplementedException();
        }

        [return: MessageParameter(Name = "response")]
        public Task<string> invokeSrvAsync(string request)
        {
            throw new NotImplementedException();
        }

        public RollbackVoucherDataResponse RollbackVoucherData(RollbackVoucherDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<RollbackVoucherDataResponse> RollbackVoucherDataAsync(RollbackVoucherDataRequest request)
        {
            throw new NotImplementedException();
        }

        public RunCommandResponse RunCommand(RunCommandRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<RunCommandResponse> RunCommandAsync(RunCommandRequest request)
        {
            throw new NotImplementedException();
        }

        [return: MessageParameter(Name = "response")]
        public string syncProd(string request)
        {
            throw new NotImplementedException();
        }

        [return: MessageParameter(Name = "response")]
        public Task<string> syncProdAsync(string request)
        {
            throw new NotImplementedException();
        }

        public TIPTOPGateWayResponse TIPTOPGateWay(TIPTOPGateWayRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<TIPTOPGateWayResponse> TIPTOPGateWayAsync(TIPTOPGateWayRequest request)
        {
            throw new NotImplementedException();
        }

        public UpdateCountingLabelDataResponse UpdateCountingLabelData(UpdateCountingLabelDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<UpdateCountingLabelDataResponse> UpdateCountingLabelDataAsync(UpdateCountingLabelDataRequest request)
        {
            throw new NotImplementedException();
        }

        public UpdateMemberPointResponse UpdateMemberPoint(UpdateMemberPointRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<UpdateMemberPointResponse> UpdateMemberPointAsync(UpdateMemberPointRequest request)
        {
            throw new NotImplementedException();
        }

        public UpdatePaymentInfoResponse UpdatePaymentInfo(UpdatePaymentInfoRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<UpdatePaymentInfoResponse> UpdatePaymentInfoAsync(UpdatePaymentInfoRequest request)
        {
            throw new NotImplementedException();
        }

        public UpdateWOIssueDataResponse UpdateWOIssueData(UpdateWOIssueDataRequest request)
        {
            throw new NotImplementedException();
        }

        public Task<UpdateWOIssueDataResponse> UpdateWOIssueDataAsync(UpdateWOIssueDataRequest request)
        {
            throw new NotImplementedException();
        }
    }
}
