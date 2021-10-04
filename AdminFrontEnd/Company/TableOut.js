class TableOut extends Output{
    constructor(tableId) {
        super();
        this.tableId = tableId;
    }
    printItem(company){
        let tableId = "#" + this.tableId;
        let content = `<tr id="${company.companyJSON.content}">
            <td scope="row" class="companyName" >${company.companyJSON.content}</td>
            <th scope="col">
                <button type="button" class="btn btn-danger removeOnClick">Delete</button>
            </th>
            <th scope="col">
                <button type="button" class="btn btn-success viewClick">View</button>
            </th>
        </tr>`
        $(tableId).prepend(content)
        console.log("Printing")
    }
    removeItem(company){
        let rowId = "#" + company.companyJSON.content;
        console.log(company.companyJSON.content)
        $(rowId).remove()
    }

    viewSingleCompany(company){
        let value = $("#additionalScrapeParameters").val()
        $("#parameterTable").html("")

        addCompanyTickerToDropdown(company.companyJSON.Ticker, "")

        $("#tickerDropDown").val(company.companyJSON.Ticker).change()

        $("#companyNameInput").val(company.companyJSON.content)

        if (company.companyJSON.Associated1 != null){
            let tableRow = `
            <tr>
                <td scope="row" class="parameterName">${company.companyJSON.Associated1}</td>
                <th scope="col">
                    <button type="button" class="btn btn-danger removeOnClick">Delete</button>
                </th>
            </tr>`
            $("#parameterTable").prepend(tableRow)
            $("#additionalScrapeParameters").val("")
        }
        if (company.companyJSON.Associated2 != null){
            let tableRow = `
            <tr>
                <td scope="row" class="parameterName">${company.companyJSON.Associated2}</td>
                <th scope="col">
                    <button type="button" class="btn btn-danger removeOnClick">Delete</button>
                </th>
            </tr>`
            $("#parameterTable").prepend(tableRow)
            $("#additionalScrapeParameters").val("")
        }
        if (company.companyJSON.Associated3 != null){
            let tableRow = `
            <tr>
                <td scope="row" class="parameterName">${company.companyJSON.Associated3}</td>
                <th scope="col">
                    <button type="button" class="btn btn-danger removeOnClick">Delete</button>
                </th>
            </tr>`
            $("#parameterTable").prepend(tableRow)
            $("#additionalScrapeParameters").val("")
        }
        // company.companyJSON.Associated1
        // let tableRow = `
        //     <tr>
        //         <td scope="row" class="parameterName">${company.companyJSON.Associated1}</td>
        //         <th scope="col">
        //             <button type="button" class="btn btn-danger removeOnClick">Delete</button>
        //         </th>
        //     </tr>`
        // $("#parameterTable").prepend(tableRow)
        // $("#additionalScrapeParameters").val("")
    }

    getCompanyFromPage(){
        let formData =  getFormDataFromPage();
        if (formData == null){
            return null
        }
        let company = new Company(formData)
        console.log("New Company")
        return company
    }
}