<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fashionstore.dao.ProductDAO" %>
<%@ page import="com.fashionstore.model.Product" %>
<%@ page import="java.util.List" %>
<%
    ProductDAO dao = new ProductDAO();
    List<Product> list = dao.getAllActiveProducts();
    out.println("<h3>Total products: " + list.size() + "</h3><ul>");
    for(Product p : list) {
        out.println("<li>" + p.getProductName() + " - Price: " + p.getUnitPrice() + "</li>");
    }
    out.println("</ul>");
%>
