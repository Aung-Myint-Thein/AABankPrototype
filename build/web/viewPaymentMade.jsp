<%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
  "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="db" scope="request" class="test.DbBean" />
<jsp:setProperty name="db" property="*" />


<%
    // only admins can see this page
    if (session.getAttribute("authenticatedAdmin")==null){
         %> <jsp:forward page = "login.html" /> <%
    }
%>



<%!
        ResultSet rs = null ;
        ResultSetMetaData rsmd = null ;
        int numColumns ;
        int i;
        double balanceTotal = 0;
%>


<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>View Payment Made</title>
  </head>

  <body>
      View Payment Made to Payment Gateway as Recorded in the Bank's Database<br/>
      Do check that this tallies with the <a href="http://10.0.2.57/aapaymentgw">total payment received by the Gateway</a><br/><br/>
      <a href="loginSuccessAdmin.jsp">Back to main menu</a><br/><br/>
    <%
    db.connect();

    try {
      db.execSQL("USE bank");
      rs = db.execSQL("SELECT * FROM payments");
      rsmd = rs.getMetaData();
      numColumns = rsmd.getColumnCount();
    } catch (SQLException e) {
    %>An error has occurred: <%=e.getMessage()%><%
    }

    %>
    <table border="1">
      <thead>
        <tr>
          <td>ID</td>
          <td>Payee ID</td>
          <td>Amount</td>
          <td>Reference ID</td>
          <td>Date stamp</td>
        </tr>
      </thead>
          <%
    while (rs.next()) {
      balanceTotal += rs.getDouble("payment");
          %>
      <tr>
        <td><%= rs.getString("id")%></td>
        <td><%= rs.getString("payeeId")%></td>
        <td><%= rs.getString("payment")%></td>
        <td><%= rs.getString("refId")%></td>
        <td><%= rs.getString("created")%></td>
      </tr>
      <%
    }
      %>
    </table>
    <h2>Total Payment Made so Far: <%=balanceTotal%></h2>
    <%
    balanceTotal = 0;
    db.close();
    %>
  </body>

</html>
