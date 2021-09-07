# Sass(SCSS)
> 2021.04.08
> https://heropy.blog/2018/01/31/sass/

## CSS Preprocessor
- SCSS 문법으로 작성하고 Compile => css

## 컴파일 방법
### node-sass
- node-sass는 Node.js를 컴파일러인 LibSass에 바인딩한 라이브러리 입니다.
- NPM으로 전역 설치하여 사용합니다.

```shell
$ npm install -g node-sass
```

### Intellij
- SCSS 플러그인 활성화
  

### vscode
> https://okayoon.tistory.com/entry/VSCode-extension%EC%9C%BC%EB%A1%9C-SASSSCSS%EB%A5%BC-%EC%82%AC%EC%9A%A9%ED%95%B4%EB%B3%B4%EC%9E%90
- vscode extention: Live Sass Compiler


## 주요 문법 
### 중첩 
```scss
.section {
  width: 100%;
  .list {
    padding: 20px;
    li {
      float: left;
    }
  }
}
```

```scss
.section {
  width: 100%;
}
.section .list {
  padding: 20px;
}
.section .list li {
  float: left;
}
```


### Ampersand (상위 선택자 참조)