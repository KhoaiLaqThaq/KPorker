const ROLE_PREFIX = {
    ADMIN: 'ROLE_ADMIN',
    GROUP: 'ROLE_GROUP',					// Nhom quyen
    USER: 'ROLE_USER',                      // Nguoi dung

    FARM: 'ROLE_FARM',                      // trai
    BARN: 'ROLE_BARN',						// Chuong

    // processorder
    GOODS_ISSUE: 'ROLE_GOODS_ISSUE',		// Xuat kho
    GI_REQUISITION: 'ROLE_GI_REQUISITION',  // phieu Yeu cau xuat kho
    GOODS_RECEIPT: 'ROLE_GOODS_RECEIPT',     // nhap kho
    GR_REQUISITION: 'ROLE_GR_REQUISITION',	// phieu Nhap kho
    GOODS_ATTRITION: 'ROLE_GOODS_ATTRITION',    // xuat tieu hao

    PROCESS_ORDER: 'ROLE_PROCESS_ORDER',    //
    DA_WEIGHT: 'ROLE_DA_WEIGHT',			// Ghi nhan khoi luong
    PIG_CULLING: 'ROLE_PIG_CULLING',        // Ghi nhan heo thai loai
    PIG_ENTRY: 'ROLE_PIG_ENTRY',            // nhap dan
    PIG_PRODUCTION: 'ROLE_PIG_PRODUCTION',  // nhap heo thanh pham
    PROPOSAL: 'ROLE_PROPOSAL',              // De xuat ban heo
    PLAN: 'ROLE_PLAN',                      // ke hoach trong chuong
    PURCHASE_REQUISITION: 'ROLE_PURCHASE_REQUISITION', // yeu cau mua hang
    WEIGHT_NOTE: 'ROLE_WEIGHT_NOTE',        // ghi nhan trong luong
    // stock
    STOCK_COUNT: 'ROLE_STOCK_COUNT',
    INSTOCK: 'ROLE_INSTOCK',
    MATERIAL: 'ROLE_MATERIAL',

    // hach toan
    GENERAL_LEDGER: 'ROLE_GENERAL_LEDGER',  // hach toan

    FINISH_PRODUCT: 'ROLE_FINISH_PRODUCT',
    TASK: 'ROLE_TASK',                      // quan ly cong viec
    DOCUMENT: 'ROLE_DOCUMENT',              // quan ly tai lieu
    REPORT: 'ROLE_REPORT'
}

const LABEL_ROLE_GROUP = {
    ROLE_ADMIN: 'Quyền quản trị',
    ROLE_GROUP: 'Quyền quản lý nhóm quyền',
    ROLE_USER: 'Quyền quản lý người dùng',

    ROLE_FARM: 'Quyền quản lý trại',
    ROLE_BARN: 'Quyền quản lý chuồng',

    // process order
    ROLE_PROCESS_ORDER: "Nhóm quyền lệnh sản xuất",
    ROLE_FINISH_PRODUCT: 'Nhóm quyền nhập heo thành phẩm',
    ROLE_GOODS_ISSUE: "Nhóm quyền xuất kho",
    ROLE_GI_REQUISITION: "Nhóm quyền phiếu xuất kho",
    ROLE_GOODS_RECEIPT: "Nhóm quyền nhập kho",
    ROLE_GR_REQUISITION: "Nhóm quyền phiếu nhập kho",
    ROLE_DA_WEIGHT: "Nhóm quyền ghi nhận khối lượng",
    ROLE_PIG_CULLING: "Nhóm quyền ghi nhận heo thải loại",
    ROLE_PIG_ENTRY: "Nhóm quyền nhập đàn",
    ROLE_PIG_PRODUCTION: 'Nhóm quyền ghi nhận heo thành phẩm',
    ROLE_PROPOSAL: "Nhóm quyền đề xuất bán heo",
    ROLE_PLAN: "Nhóm quyền kế hoạch trống chuồng",
    ROLE_WEIGHT_NOTE: "Nhóm quyền ghi nhận trọng lượng",

    ROLE_GOODS_ATTRITION: "Nhóm quyền xuất tiêu hao",

    ROLE_PURCHASE_REQUISITION: "Nhóm quyền yêu cầu mua hàng",
    ROLE_STOCK_COUNT: "Nhóm quyền tồn kho theo SAP",
    ROLE_INSTOCK: "Nhóm quyền tồn kho",
    ROLE_MATERIAL: "Nhóm quyền quản lý vật tư",
    // hach toan
    ROLE_GENERAL_LEDGER: "Nhóm quyền hạch toán chi phí",

    ROLE_TASK: "Nhóm quyền quản lý công việc",
    ROLE_DOCUMENT: "Nhóm quyền quản lý tài liệu",
    ROLE_REPORT: "Nhóm quyền báo cáo"
}

const GroupFormNewComponent = function() {

    let roleAdmins = [],
        roleGroups = [],
        roleUsers = [],
        roleFarms = [],
        roleBarns = [],

        // processorder
        roleFinishProducts = [],
        roleGoodsIssues = [],
        roleGIRequisitions = [],
        roleGoodsReceipt = [],
        roleGRRequisitions = [],
        roleProcessOrders = [],
        roleDAWeight = [],
        roleGoodsAttrition = [],
        rolePigCullings = [],
        rolePigEntries = [],
        rolePigProductions = [],
        roleProposals = [],
        rolePlan = [],
        roleWeightNotes = [],

        rolePurchaseRequisitions = [],
        roleMaterials = [],
        roleStockCounts = [],
        roleInstocks = [],
        roleGeneralLedgers = [],
        // common
        roleTasks = [],
        roleDocuments = [],
        roleReports = []
    ;

    const _onLoaded = function() {
        $.ajax({
            url: `${getContext()}/api/getRoles`,
            method: 'GET',
            contentType: 'application/json',
            success: function(response) {
                if (response) {
                    _handleRolesToRoleMap(response);
                    _eventRoleCheck();
                }
            }, error: function(error) {
                console.log(error);
            }
        });
    }

    const _handleRolesToRoleMap = function(roles) {
        if (roles && roles.length > 0) {
            roleAdmins = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.ADMIN))
            roleGroups = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.GROUP)).sort(sort_by('description', false, (a) => a.toUpperCase()))
            roleUsers = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.USER)).sort(sort_by('description', false, (a) => a.toUpperCase()))
            roleFarms = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.FARM)).sort(sort_by('description', false, (a) => a.toUpperCase()))
            roleBarns = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.BARN)).sort(sort_by('description', false, (a) => a.toUpperCase()))

            // process order
            roleFinishProducts = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.FINISH_PRODUCT)).sort(sort_by('description', false, (a) => a.toUpperCase()))

            roleGoodsIssues = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.GOODS_ISSUE)).sort(sort_by('description', false, (a) => a.toUpperCase()))
            roleGIRequisitions = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.GI_REQUISITION)).sort(sort_by('description', false, (a) => a.toUpperCase()))

            roleGoodsReceipt = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.GOODS_RECEIPT)).sort(sort_by('description', false, (a) => a.toUpperCase()))
            roleGRRequisitions = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.GR_REQUISITION)).sort(sort_by('description', false, (a) => a.toUpperCase()))

            roleProcessOrders = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.PROCESS_ORDER)).sort(sort_by('description', false, (a) => a.toUpperCase()))
            roleDAWeight = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.DA_WEIGHT)).sort(sort_by('description', false, (a) => a.toUpperCase()))
            rolePigCullings = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.PIG_CULLING)).sort(sort_by('description', false, (a) => a.toUpperCase()))
            rolePigEntries = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.PIG_ENTRY)).sort(sort_by('description', false, (a) => a.toUpperCase()))
            roleProposals = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.PROPOSAL)).sort(sort_by('description', false, (a) => a.toUpperCase()))

            rolePigProductions = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.PIG_PRODUCTION)).sort(sort_by('description', false, (a) => a.toUpperCase()))
            rolePlan = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.PLAN)).sort(sort_by('description', false, (a) => a.toUpperCase()))
            roleWeightNotes = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.WEIGHT_NOTE)).sort(sort_by('description', false, (a) => a.toUpperCase()))

            roleGoodsAttrition = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.GOODS_ATTRITION)).sort(sort_by('description', false, (a) => a.toUpperCase()))

            rolePurchaseRequisitions = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.PURCHASE_REQUISITION)).sort(sort_by('description', false, (a) => a.toUpperCase()))
            roleStockCounts = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.STOCK_COUNT)).sort(sort_by('description', false, (a) => a.toUpperCase()))
            roleInstocks = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.INSTOCK)).sort(sort_by('description', false, (a) => a.toUpperCase()))
            roleMaterials = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.MATERIAL)).sort(sort_by('description', false, (a) => a.toUpperCase()))
            // general ledger
            roleGeneralLedgers = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.GENERAL_LEDGER)).sort(sort_by('description', false, (a) => a.toUpperCase()))
            roleTasks = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.TASK)).sort(sort_by('description', false, (a) => a.toUpperCase()))
            roleDocuments = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.DOCUMENT)).sort(sort_by('description', false, (a) => a.toUpperCase()))
            roleReports = roles.filter((role) => role.name?.startsWith(ROLE_PREFIX.REPORT)).sort(sort_by('description', false, (a) => a.toUpperCase()))
        }

        let mapRoleSelector = $('#mapRoles');
        let labelRoleGroup = '';
        // admin
        if (roleAdmins.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_ADMIN}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleAdmins.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleAdmins[i]))
            }
        }

        // group
        if (roleGroups.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_GROUP}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleGroups.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleGroups[i]))
            }
        }

        // user
        if (roleUsers.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_USER}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleUsers.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleUsers[i]))
            }
        }
        // barn
        if (roleFarms.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_FARM}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleFarms.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleFarms[i]))
            }
        }
        // barn
        if (roleBarns.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_BARN}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleBarns.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleBarns[i]))
            }
        }

        // goods_issue
        if (roleGoodsIssues.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_GOODS_ISSUE}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleGoodsIssues.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleGoodsIssues[i]))
            }
        }

        // gi requisition
        if (roleGIRequisitions.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_GI_REQUISITION}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleGIRequisitions.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleGIRequisitions[i]))
            }
        }

        // gr
        if (roleGoodsReceipt.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_GOODS_RECEIPT}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleGoodsReceipt.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleGoodsReceipt[i]))
            }
        }

        // gr requisition
        if (roleGRRequisitions.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_GR_REQUISITION}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleGRRequisitions.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleGRRequisitions[i]))
            }
        }

        // process order
        if (roleProcessOrders.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_PROCESS_ORDER}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleProcessOrders.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleProcessOrders[i]))
            }
        }
        // finish products
        if (roleFinishProducts.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_FINISH_PRODUCT}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleFinishProducts.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleFinishProducts[i]))
            }
        }

        // DA weight
        if (roleDAWeight.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_DA_WEIGHT}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleDAWeight.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleDAWeight[i]))
            }
        }
        // pig culling
        if (rolePigCullings.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_PIG_CULLING}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < rolePigCullings.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(rolePigCullings[i]))
            }
        }

        // pig entry
        if (rolePigEntries.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_PIG_ENTRY}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < rolePigEntries.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(rolePigEntries[i]))
            }
        }
        // pig production
        if (rolePigProductions.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_PIG_PRODUCTION}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < rolePigProductions.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(rolePigProductions[i]))
            }
        }
        // proposal
        if (roleProposals.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_PROPOSAL}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleProposals.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleProposals[i]))
            }
        }

        // weight note
        if (roleWeightNotes.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_WEIGHT_NOTE}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleWeightNotes.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleWeightNotes[i]))
            }
        }

        // plan
        if (rolePlan.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_PLAN}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < rolePlan.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(rolePlan[i]))
            }
        }


        // Xuat tieu hao
        if (roleGoodsAttrition.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_GOODS_ATTRITION}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleGoodsAttrition.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleGoodsAttrition[i]))
            }
        }

        // yeu cau mua hang
        if (rolePurchaseRequisitions.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_PURCHASE_REQUISITION}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < rolePurchaseRequisitions.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(rolePurchaseRequisitions[i]))
            }
        }
        // stock count
        if (roleStockCounts.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_STOCK_COUNT}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleStockCounts.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleStockCounts[i]))
            }
        }
        // instock
        if (roleInstocks.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_INSTOCK}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleInstocks.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleInstocks[i]))
            }
        }

        // material
        if (roleMaterials.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_MATERIAL}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleMaterials.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleMaterials[i]))
            }
        }

        // General ledger
        if (roleGeneralLedgers.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_GENERAL_LEDGER}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleGeneralLedgers.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleGeneralLedgers[i]))
            }
        }

        // task
        if (roleTasks.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_TASK}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleTasks.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleTasks[i]))
            }
        }

        // document
        if (roleDocuments.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_DOCUMENT}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleDocuments.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleDocuments[i]))
            }
        }

        // document
        if (roleReports.length > 0) {
            labelRoleGroup = `<div class="col-12"><p class="fw-bold">${LABEL_ROLE_GROUP.ROLE_REPORT}</p></div>`;
            mapRoleSelector.append(labelRoleGroup);
            // loop
            for (let i = 0; i < roleReports.length; i++) {
                mapRoleSelector.append(_generateTemplateItem(roleReports[i]))
            }
        }

    }

    const _generateTemplateItem = function(role) {
        return `
            <div class="col-12 col-sm-6 col-md-6 col-lg-4 col-xl-3 mb-3">
                <div class="custom-control custom-checkbox">
                    <input type="checkbox" class=" roleChecks" value="${role.name}" id="${role.name}">
                    <label class="prevent-select" for="${role.name}">${role.description ? role.description : role.name}</label>
                </div>
            </div>
        `;
    }

    /**
     * Define site touring...
     * @private
     */
    const _defineSiteTouring = function() {
        introJs().setOptions({
            steps: [
                {
                    element: document.querySelector('.card-body'),
                    intro: 'Card bory'
                },
                {
                    element: document.querySelector('#group__desc'),
                    intro: 'description'
                }
            ]
        }).start();
    }

    const sort_by = (field, reverse, primer) => {

        const key = primer ?
            function(x) {
                return primer(x[field])
            } :
            function(x) {
                return x[field]
            };

        reverse = !reverse ? 1 : -1;

        return function(a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    }

    let roleNameExisted = $("input[name='roleList']").val();
    const _eventRoleCheck = function() {
        $('.roleChecks').change((e) => {
            let currentSelect = e.currentTarget.defaultValue;
            if (!roleNameExisted) roleNameExisted = "";
            if (e.currentTarget.checked)
                roleNameExisted += `${currentSelect},`;
            else {
                if (roleNameExisted.length > 0) {
                    roleNameExisted = roleNameExisted.replace(currentSelect+",", "");
                }
            }

            $("input[name='roleList']").val(roleNameExisted);
        });
    }

    return {
        init: function() {
            _onLoaded();
        },
        siteTour: function() {
            _defineSiteTouring()
        }
    }
}();

document.addEventListener('DOMContentLoaded', function() {
    GroupFormNewComponent.init();
})
