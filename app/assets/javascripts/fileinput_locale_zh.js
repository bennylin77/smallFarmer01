/*!
 * FileInput Chinese Translations
 *
 * This file must be loaded after 'fileinput.js'. Patterns in braces '{}', or
 * any HTML markup tags in the messages must not be converted or translated.
 *
 * @see http://github.com/kartik-v/bootstrap-fileinput
 * @author kangqf <kangqingfei@gmail.com>
 *
 * NOTE: this file must be saved in UTF-8 encoding.
 */
(function ($) {
    "use strict";

    $.fn.fileinput.locales.zh = {
        fileSingle: '圖片',
        filePlural: '多個圖片',
        browseLabel: '選擇圖片 &hellip;',
        removeLabel: '移除',
        removeTitle: '清除選中文件',
        cancelLabel: '取消',
        cancelTitle: '取消進行中的上傳',
        uploadLabel: '上傳',
        uploadTitle: '上傳選中文件',
        msgSizeTooLarge: '文件 "{name}" (<b>{size} KB</b>) 超過了允許大小 <b>{maxSize} KB</b>. 請重新上傳!',
        msgFilesTooLess: '你必须选择最少 <b>{n}</b> {files} 来上传. 请重新上传!',
        msgFilesTooMany: '選擇的上傳圖片個數 <b>({n})</b> 超出最大圖片限制個數 <b>{m}</b>.',
        msgFileNotFound: '文件 "{name}" 未找到!',
        msgFileSecured: '安全限制，为了防止读取文件 "{name}".',
        msgFileNotReadable: '文件 "{name}" 不可读.',
        msgFilePreviewAborted: '取消 "{name}" 的预览.',
        msgFilePreviewError: '读取 "{name}" 时出现了一个错误.',
        msgInvalidFileType: '不正确的类型 "{name}". 只支持 "{types}" 类型的文件.',
        msgInvalidFileExtension: '不正确的文件扩展名 "{name}". 只支持 "{extensions}" 的文件扩展名.',
        msgValidationError: '文件上传错误',
        msgLoading: '加载第 {index} 文件 共 {files} &hellip;',
        msgProgress: '加载第 {index} 文件 共 {files} - {name} - {percent}% 完成.',
        msgSelected: '{n} {files} 選取',
        msgFoldersNotAllowed: '只支持拖拽文件! 跳过 {n} 拖拽的文件夹.',
        dropZoneTitle: '拖曳圖片到這裡 &hellip;',
        slugCallback: function(text) {
            return text ? text.split(/(\\|\/)/g).pop().replace(/[^\w\u4e00-\u9fa5\-.\\\/ ]+/g, '') : '';
        }
    };

    $.extend($.fn.fileinput.defaults, $.fn.fileinput.locales.zh);
})(window.jQuery);
