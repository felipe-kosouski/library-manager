<template>
  <div>
    <h1>Library Books</h1>
    <ul>
      <li v-for="book in books" :key="book.id">
        <a :href="`/books/${book.id}`">
          <Book :book="book"/>
        </a>
      </li>
    </ul>
  </div>
</template>

<script>
import Book from "./book.vue";
export default {
  components: {Book},
  data() {
    return {
      books: []
    };
  },
  mounted() {
    fetch('api/v1/books')
        .then(response => response.json())
        .then(data => {
          this.books = data;
        });
  },
};
</script>