<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <link rel="shortcut icon" href="../img/favicon1.ico" type="image/x-icon" >
  <link rel="icon" href="../img/favicon1.ico" type="image/x-icon" >
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>재고현황</title>

  <!-- Custom fonts for this template-->
  <link href="../vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">

  <!-- Custom styles for this template-->
  <link href="../css/sb-admin-2.min.css" rel="stylesheet">

  <!-- Custom styles for this page -->
  <link href="../vendor/datatables/dataTables.bootstrap4.min.css" rel="stylesheet">
  
</head>
<body id="page-top">
  <!-- Page Wrapper -->
  <div id="wrapper">
    <c:set value="admin" var="navRecall"/>
    <%@ include file="../common/_navigator.jspf" %>
    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">
      <!-- Main Content -->
      <div id="content">
        <%@ include file="../common/_top.jspf" %>
        <!-- Begin Page Content -->
        <div class="container-fluid">
        
          <!-- Page Heading -->
          <div class="d-sm-flex align-items-center justify-content-between mb-4">
            <h1 class="h3 mb-0 text-gray-600 boldfont">재고현황</h1>
          </div>
          
          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3 d-sm-flex align-items-center justify-content-between">
              <h6 class="m-0 font-weight-bold text-primary d-sm-inline-block" style="line-height:2">${requestScope.curDate}</h6>
              <div class="dropdown no-arrow">
                <button class="dropdown-toggle btn btn-primary btn-sm shadow-sm" role="button" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                  <i class="fas fa-list-ul"></i>&nbsp;&nbsp;제품종류
                </button>
                <div class="dropdown-menu dropdown-menu-right shadow animated--fade-in" aria-labelledby="dropdownMenuLink">
                  <a class="dropdown-item" href="AdminProc?action=categoryProductList&cName=A">육류</a>
                  <a class="dropdown-item" href="AdminProc?action=categoryProductList&cName=B">해산물</a>
                  <a class="dropdown-item" href="AdminProc?action=categoryProductList&cName=C">바베큐</a>
                  <a class="dropdown-item" href="AdminProc?action=categoryProductList&cName=D">야채/과일</a>
                  <a class="dropdown-item" href="AdminProc?action=categoryProductList&cName=E">향신료</a>
                </div>
              </div>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                  <colgroup>
					<col style="width:15%">
					<col style="width:30%">
					<col style="width:15%">
					<col style="width:15%">
					<col style="width:15%">
				  </colgroup>
                  <thead>
                    <tr>
                      <th style="text-align: center;">상품코드</th>
                      <th style="text-align: center;">상품이름</th>
                      <th style="text-align: center;">재고수량</th>
                      <th style="text-align: center;">출고대기수량</th>
                      <th style="text-align: center;">입고예정수량</th>
                    </tr>
                  </thead>
                  <tbody>
                  	<c:set var="productList" value ="${requestScope.productList}"/>
					<c:forEach var="product" items="${productList}">
	                 <tr>
                      <td style="text-align: center;">${product.pCode}</td>
                      <td style="text-align: left;">${product.pName}</td>
                      <td style="text-align: right;">${product.pQuantity}개</td>
                      <td style="text-align: right;">${product.oQuantity}개</td>
                      <td style="text-align: right;">${product.sQuantity}개</td>
                   	</tr>
                 	</c:forEach>
                 </tbody>
               </table>
             </div>
           </div>
         </div>
          <!-- 위까지 그래프  -->
          <button type="button" onclick="exportTableToCsv('dataTable', 'Export example')">
        Export
    </button>
          
        </div>
        <!-- /.container-fluid -->
      </div>
      <!-- End of Main Content -->
      <%@ include file="../common/_bottom.jspf" %>
    </div>
    <!-- End of Content Wrapper -->
  </div>
  <!-- End of Page Wrapper -->

  <!-- Bootstrap core JavaScript-->
  <script src="../vendor/jquery/jquery.min.js"></script>
  <script src="../vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

  <!-- Core plugin JavaScript-->
  <script src="../vendor/jquery-easing/jquery.easing.min.js"></script>

  <!-- Custom scripts for all pages-->
  <script src="../js/sb-admin-2.min.js"></script>

  <!-- Page level plugins -->
  <script src="../vendor/datatables/jquery.dataTables.min.js"></script>
  <script src="../vendor/datatables/dataTables.bootstrap4.min.js"></script>

  <!-- Page level custom scripts -->
  <script src="../js/demo/datatables-demo.js"></script>
  
  <script>
  function exportTableToCsv(tableId, filename) {
	    if (filename == null || typeof filename == undefined)
	        filename = tableId;
	    filename += ".csv";
	 
	    var BOM = "\uFEFF"; //utf-8 format setting
	 
	    var table = document.getElementById(tableId);
	    var csvString = BOM;
	    for (var rowCnt = 0; rowCnt < table.rows.length; rowCnt++) { //table.rows.length = table의 row갯수
	    	document.write(table.rows.length);
	        var rowData = table.rows[rowCnt].cells;
	        for (var colCnt = 0; colCnt < rowData.length; colCnt++) { //row data.length = 각 row의 cell 갯수
	        	document.write(rowData.length);
	            var columnData = rowData[colCnt].innerHTML;
	            
	            if (columnData == null || columnData.length == 0) {
	                columnData = "".replace(/"/g, '""');
	            }
	            else {
	                columnData = columnData.toString().replace(/"/g, '""'); // escape double quotes
	            }
	            csvString = csvString + '"' + columnData + '",';
	        }
	        csvString = csvString.substring(0, csvString.length - 1);
	        csvString = csvString + "\r\n";
	    }
	    csvString = csvString.substring(0, csvString.length - 1);
	 
	    // IE 10, 11, Edge Run
	    if (window.navigator && window.navigator.msSaveOrOpenBlob) {
	 
	        var blob = new Blob([decodeURIComponent(csvString)], {
	            type: 'text/csv;charset=utf8'
	        });
	 
	        window.navigator.msSaveOrOpenBlob(blob, filename);
	 
	    } else if (window.Blob && window.URL) {
	        // HTML5 Blob
	        var blob = new Blob([csvString], { type: 'text/csv;charset=utf8' });
	        var csvUrl = URL.createObjectURL(blob);
	        var a = document.createElement('a');
	        a.setAttribute('style', 'display:none');
	        a.setAttribute('href', csvUrl);
	        a.setAttribute('download', filename);
	        document.body.appendChild(a);
	 
	        a.click()
	        a.remove();
	    } else {
	        // Data URI
	        var csvData = 'data:application/csv;charset=utf-8,' + encodeURIComponent(csvString);
	        var blob = new Blob([csvString], { type: 'text/csv;charset=utf8' });
	        var csvUrl = URL.createObjectURL(blob);
	        var a = document.createElement('a');
	        a.setAttribute('style', 'display:none');
	        a.setAttribute('target', '_blank');
	        a.setAttribute('href', csvData);
	        a.setAttribute('download', filename);
	        document.body.appendChild(a);
	        a.click()
	        a.remove();
	    }
	}
  </script>
  
	
</body>
</html>
<%@ include file="../common/_messageModal.jspf" %>